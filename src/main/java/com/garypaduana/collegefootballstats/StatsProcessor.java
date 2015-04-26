package com.garypaduana.collegefootballstats;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;

public class StatsProcessor {
	
	// This file will be created at first connection if it doesn't exist.
	private static final String DB_URL = "jdbc:sqlite:./resources/data.db";
	private static final String ROOT_DIR = "./resources";
	private static final String DB_CREATE_PATH = "./resources/createTables.sql";
	
	/**
	 * Then a real coding problem, parsing some college football stats: 
	 * http://datahub.io/dataset/college-football-statistics-2005-2013
	 * Grab all the zip files for the years 2005-2013. They aren't terribly large. 
	 * Each zip has CSV files with different stats. Come up with a database schema 
	 * to store them all. Parse all the files and combine them into a database. 
	 * Extra credit if you also can combine all the unique stadiums referenced 
	 * into an XML format of your invention. You don't need to do this in Java, 
	 * but keep it mainstream.
	 * @param args
	 */
	public static void main(String args[]){
		
		try {
			generateSchema();
			processFiles();
		} catch (ClassNotFoundException | SQLException | IOException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 
	 * @throws NumberFormatException
	 * @throws SQLException
	 * @throws ClassNotFoundException
	 * @throws IOException
	 */
	private static void processFiles() throws NumberFormatException, SQLException, 
		ClassNotFoundException, IOException{
		File rootDir = new File(ROOT_DIR);
		Statement statement = null;
		Connection conn = null;
		BufferedReader br = null;
		PreparedStatement pStatement = null;
		
		try {
			Class.forName("org.sqlite.JDBC");
			conn = DriverManager.getConnection(DB_URL);
			conn.setAutoCommit(false);
            if (conn != null) {
            	statement = conn.createStatement();
            	
                for(File f : recurse(rootDir, ".+csv")){
                	int year = findYearFromFile(f);
                	System.out.println(year + ", " + f.getAbsolutePath());
                	String tableName = decideTableName(f);
                	
                	br = new BufferedReader(new FileReader(f));
                	String line;
                	int lineNumber = 0;
                	String columnNames;
                	int modifier = 0;
                	while((line = br.readLine()) != null){
                		if(lineNumber == 0){
                			columnNames = line;
                			
                			if(tableName.equals("conferences") ||
                			   tableName.equals("teams") ||
                			   tableName.equals("players") ||
                			   tableName.equals("stadiums")){
                				columnNames = "\"Year\"," + columnNames;
                				modifier = 1;
                			}
                			
                			String query = "INSERT INTO " + tableName +
                                	" (" + cleanColumnNames(columnNames) + ") VALUES (" +
                    				columnNameMarkers(columnNames.split(",").length) + ")";
                			pStatement = conn.prepareStatement(query);
                			lineNumber++;
                			continue;
                		}
                		
                		if(modifier == 1){
            				pStatement.setInt(1, year);
            			}
                		
                		CSVRecord parts = CSVParser.parse(line, CSVFormat.DEFAULT).getRecords().get(0);
                		
                		for(int i = 1; i <= parts.size(); i++){
                			if(isInteger(parts.get(i - 1))){
                				pStatement.setInt(i + modifier, Integer.parseInt(parts.get(i - 1)));
                			}
                			else if(parts.get(i - 1).length() > 0){
                				pStatement.setString(i + modifier, parts.get(i - 1));
                			}
                			else{
                				pStatement.setString(i + modifier, null);
                			}
                		}
                		pStatement.addBatch();
                		
                		if(lineNumber % 1000 == 0){
                			pStatement.executeBatch();
                		}
                		lineNumber++;
                	}
                	if(pStatement != null){
                		pStatement.executeBatch();
                	}
                }
            }
            conn.commit();
		}
		finally{
			if(statement != null){
				statement.close();
			}
			if(conn != null){
				conn.close();
			}
			if(br != null){
				br.close();
			}
		}
	}
	
	/**
	 * Executes the createTables.sql script to drop all tables if they exist and then
	 * create new tables.
	 * 
	 * @throws SQLException
	 * @throws IOException
	 * @throws ClassNotFoundException
	 */
	private static void generateSchema() throws SQLException, IOException, ClassNotFoundException{
		File f = new File(DB_CREATE_PATH);
		
		BufferedReader br = null;
		StringBuilder sb = new StringBuilder();
		Statement statement = null;
		Connection conn = null;

		try{
			br = new BufferedReader(new FileReader(f));
			String line;
			while((line = br.readLine()) != null){
				sb.append(line);
			}
			
			Class.forName("org.sqlite.JDBC");
			conn = DriverManager.getConnection(DB_URL);
			statement = conn.createStatement();
			
			for(String s : sb.toString().split(";")){
				statement.execute(s);
			}
		}
		finally{
			if(statement != null){
				statement.close();
			}
			if(conn != null){
				conn.close();
			}
			if(br != null){
				br.close();
			}
		}
	}
	
	/**
	 * Looks at the absolute path of the File argument and attempts
	 * to return the 4-digit year contained within the path.  This value
	 * is expected to be present so an IllegalArgumentException will be
	 * thrown if not found.
	 * 
	 * @param f
	 * @return
	 */
	private static int findYearFromFile(File f) {
		String regex = ".+-com-(\\d{4}).+";
		
		Pattern p = Pattern.compile(regex);
		Matcher m = p.matcher(f.getAbsolutePath());
		if(m.matches()){
			return Integer.parseInt(m.group(1));
		}
		else{
			throw new IllegalArgumentException("Unable to find year for this file!");	
		}
	}

	/**
	 * Generates a String of question marks as place holders in a
	 * parameterized SQL statement.  e.g.:  "?,?,?,?,?"
	 * 
	 * @param count - the number of question marks desired
	 * @return
	 */
	private static String columnNameMarkers(int count) {
		StringBuilder sb = new StringBuilder();
		for(int i = 0; i < count; i++){
			sb.append("?,");
		}
		sb.delete(sb.length() - 1, sb.length());
		return sb.toString();
	}

	/**
	 * Recurses a file tree and returns all files that match a 
	 * specified filter.
	 * 
	 * @param root - the parent directory where the recursion begins.
	 * @param filter - a regular expression that the file's name
	 * must match in order to be included.
	 * @return
	 */
	private static List<File> recurse(File root, String filter){
	    List<File> files = new ArrayList<File>();
	    
	    for(File f : root.listFiles()){
	        if(f.isDirectory()){
	            files.addAll(recurse(f, filter));
	        }
	        else if(f.getName().matches(filter)){
	            files.add(f);
	        }
	    }
	    
	    return files;
	}
	
	/**
	 * Creates a plural form of the table name.  Underscores are used
	 * instead of dashes or spaces.  A few special cases exist for the 
	 * plural form of certain words, otherwise an "s" is appended to the
	 * name.
	 * 
	 * @param f - the csv File to be processed.  The file name is 
	 * approximately the desired table name.
	 * @return
	 */
	private static String decideTableName(File f){
		String tableName = f.getName().replace(".csv", "")
				  					  .replace("-", "_");
		if(tableName.equals("rush") ||
		   tableName.equals("pass")){
			tableName = tableName + "es";
		}
		else if(tableName.equals("team_game_statistics") || 
				tableName.equals("player_game_statistics") ||
				tableName.equals("game_statistics")){
			// keep this name
		}
		else{
			tableName = tableName + "s";
		}
		
		return tableName;
	}
	
	/**
	 * Determines if a String can be parsed as an Integer.
	 * Used when deciding what kind of parameter to set in 
	 * a prepared statement.
	 * 
	 * @param value
	 * @return
	 */
	private static boolean isInteger(String value){
		try{
			Integer.parseInt(value);
			return true;
		}
		catch(NumberFormatException ex){
			// do nothing
		}
		
		return false;
	}
	
	/**
	 * The csv column names may contain some junk characters that need
	 * to be cleaned before being used in the database.
	 * 
	 * @param columnNames
	 * @return
	 */
	private static String cleanColumnNames(String columnNames){
		columnNames = columnNames.replaceAll("\"", "")
								 .replaceAll("1st", "First")
								 .replaceAll("-", "_")
								 .replaceAll(" ", "_")
								 .replaceAll(",", ", ")
								 .replaceAll("/", "_");
		return columnNames;
	}
}
