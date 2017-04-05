package parser;

/**
 * @author Faraz Mazhar
 * BCSF14M529
 * Bottom-up parser with GUI (with hard coded algorithm)
 */

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.LinkedList;

import javax.swing.*;

class parseTableMeta
{
	public char action;
	public int state;
	
	
	public parseTableMeta() 
	{
		action = 'E';
		state = -1;
	}
}

@SuppressWarnings("serial")
class ParsingAlgo extends JFrame
{
	private Container c;
	private JTextField jtf;
	private JButton jb;
	
	private parseTableMeta[][] parseTable;
	private LinkedList<String> stack;
	private String input;
	private parseTableMeta action;
	
	private FileWriter fw;
	private BufferedWriter bw;
	private PrintWriter pw;
	
	public ParsingAlgo() 
	{
		stack = new LinkedList<String> ();
		action = new parseTableMeta();
		
		parseTable = new parseTableMeta[12][9];
		
		for (int i = 0; i < 12; i++)
		{
			for (int j = 0; j < 9; j++)
			{
				parseTable[i][j] = new parseTableMeta();
			}
		}
	}
	
	public void reduce()
	{
		int nonTerminal = 6;
		
		System.out.println("action.state: "+action.state);
		
		if (action.state == 1)
		{
			while (!(stack.getFirst().equals(Character.toString('E'))))
			{
				stack.pop();
			}
			stack.pop();
			
			stack.push("E");
			nonTerminal = 6;
		}
		else if (action.state == 2)
		{
			while (!(stack.getFirst().equals(Character.toString('T'))))
			{
				stack.pop();
			}
			stack.pop();
			
			stack.push("E");
			nonTerminal = 6;
		}
		else if (action.state == 3)
		{
			while (!(stack.getFirst().equals(Character.toString('T'))))
			{
				stack.pop();
			}
			stack.pop();
			
			stack.push("T");
			nonTerminal = 7;
		}
		else if (action.state == 4)
		{
			while (!(stack.getFirst().equals(Character.toString('F'))))
			{
				stack.pop();
			}
			stack.pop();
			
			stack.push("T");
			nonTerminal = 7;
		}
		else if (action.state == 5)
		{
			while (!(stack.getFirst().equals(Character.toString('('))))
			{
				stack.pop();
			}
			stack.pop();
			
			stack.push("F");
			nonTerminal = 8;
		}
		else if (action.state == 6)
		{
			while (!(stack.getFirst().equals("i")))
			{
				stack.pop();
			}
			stack.pop();
			
			stack.push("F");
			nonTerminal = 8;
		}
		
		System.out.println("Stack get 1: "+stack.get(1));
		stack.push(Integer.toString(parseTable[Integer.parseInt((stack.get(1)))][nonTerminal].state));
	}
	
	public void gui()
	{
		c = getContentPane();
		c.setLayout(new BorderLayout());
		
		jtf = new JTextField();
		jtf.setText("$");
		jb = new JButton("Parse");
		
		jb.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e)
			{
				parsing();
			}
		});
		
		c.add(jtf, BorderLayout.NORTH);
		c.add(jb, BorderLayout.SOUTH);
		
		Font f = new Font("ARIEL", Font.PLAIN, 25);
		
		jtf.setFont(f);
		
		setTitle("Assignment 3");
		setVisible(true);
		setSize(400, 100);
		setDefaultCloseOperation(EXIT_ON_CLOSE);
	}
	
	public void defaultParseTable()
	{
		
		//State 0
		parseTable[0][0].action = 'S';
		parseTable[0][0].state = 5;
		
		parseTable[0][3].action = 'S';
		parseTable[0][3].state = 4;
		
		parseTable[0][6].action = 'G';
		parseTable[0][6].state = 1;
		
		parseTable[0][7].action = 'G';
		parseTable[0][7].state = 2;
		
		parseTable[0][8].action = 'G';
		parseTable[0][8].state = 3;
		
		//State 1
		parseTable[1][1].action = 'S';
		parseTable[1][1].state = 6;
		
		parseTable[1][5].action = 'A';
		parseTable[1][5].state = 0;
		
		//State 2
		parseTable[2][1].action = 'R';
		parseTable[2][1].state = 2;
		
		parseTable[2][2].action = 'S';
		parseTable[2][2].state = 7;
		
		parseTable[2][4].action = 'R';
		parseTable[2][4].state = 2;
		
		parseTable[2][5].action = 'R';
		parseTable[2][5].state = 2;
		
		//State 3
		parseTable[3][1].action = 'R';
		parseTable[3][1].state = 4;
		
		parseTable[3][2].action = 'R';
		parseTable[3][2].state = 4;
		
		parseTable[3][4].action = 'R';
		parseTable[3][4].state = 4;
		
		parseTable[3][5].action = 'R';
		parseTable[3][5].state = 4;
		
		//State 4
		parseTable[4][0].action = 'S';
		parseTable[4][0].state = 5;
		
		parseTable[4][3].action = 'S';
		parseTable[4][3].state = 4;
		
		parseTable[4][6].action = 'G';
		parseTable[4][6].state = 8;
		
		parseTable[4][7].action = 'G';
		parseTable[4][7].state = 2;
		
		parseTable[4][8].action = 'G';
		parseTable[4][8].state = 3;
		
		//State 5
		parseTable[5][1].action = 'R';
		parseTable[5][1].state = 6;
		
		parseTable[5][2].action = 'R';
		parseTable[5][2].state = 6;
		
		parseTable[5][4].action = 'R';
		parseTable[5][4].state = 6;
		
		parseTable[5][5].action = 'R';
		parseTable[5][5].state = 6;
		
		//State 6
		parseTable[6][0].action = 'S';
		parseTable[6][0].state = 5;
		
		parseTable[6][3].action = 'S';
		parseTable[6][3].state = 4;
		
		parseTable[6][7].action = 'G';
		parseTable[6][7].state = 9;
		
		parseTable[6][8].action = 'G';
		parseTable[6][8].state = 3;
		
		//State 7
		parseTable[7][0].action = 'S';
		parseTable[7][0].state = 5;
		
		parseTable[7][3].action = 'S';
		parseTable[7][3].state = 4;
		
		parseTable[7][8].action = 'G';
		parseTable[7][8].state = 10;
		
		//State 8
		parseTable[8][1].action = 'S';
		parseTable[8][1].state = 6;
		
		parseTable[8][4].action = 'S';
		parseTable[8][4].state = 11;
		
		//State 9
		parseTable[9][1].action = 'R';
		parseTable[9][1].state = 1;
		
		parseTable[9][2].action = 'S';
		parseTable[9][2].state = 7;
		
		parseTable[9][4].action = 'R';
		parseTable[9][4].state = 1;
		
		parseTable[9][5].action = 'R';
		parseTable[9][5].state = 1;
		
		//State 10
		parseTable[10][1].action = 'R';
		parseTable[10][1].state = 3;
		
		parseTable[10][2].action = 'R';
		parseTable[10][2].state = 3;
		
		parseTable[10][4].action = 'R';
		parseTable[10][4].state = 3;
		
		parseTable[10][5].action = 'R';
		parseTable[10][5].state = 3;
		
		//State 11
		parseTable[11][1].action = 'R';
		parseTable[11][1].state = 5;
		
		parseTable[11][2].action = 'R';
		parseTable[11][2].state = 5;
		
		parseTable[11][4].action = 'R';
		parseTable[11][4].state = 5;
		
		parseTable[11][5].action = 'R';
		parseTable[11][5].state = 5;
	}
	
	public void toWrite(int i)
	{
		pw.println(stack.toString()+"\t\t"+input.substring(i)+"\t"+(action.action+Integer.toString(action.state)));
	}
	
	public void parsing()
	{
		input = jtf.getText();
		input = input.trim();
		
		if (input.length() <= 1)
		{
			System.out.println("Empty.");
			return;
		}
		
		if (input.charAt(0) == '$' || input.charAt(input.length()-1) != '$')
		{
			System.out.println("Wrong input.");
			return;
		}
		
		try 
		{
			fw = new FileWriter("parsed.txt");
			bw = new BufferedWriter(fw);
			pw = new PrintWriter(bw);
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
		
		stack.clear();
		
		boolean isStart = true;
		int gotoState;
		
		int i = 0; 
		
		while (i < input.length())
		{
			if (isStart)
			{
				stack.push("$");
				stack.push(Integer.toString(0));
				
				isStart = false;
			}
			
			if (input.charAt(i) == ' ')
			{
				i++;
			}
			else
			{
				gotoState = Integer.parseInt(stack.getFirst());
				
				if (input.charAt(i) == 'i')
				{	
					action.action = parseTable[gotoState][0].action;
					action.state = parseTable[gotoState][0].state;
					
					System.out.println(stack.toString()+"\t"+input.substring(i)+"\t"+(action.action+Integer.toString(action.state)));
					
					if (action.action == 'E')
					{
						pw.println(stack.toString()+"\t\t"+input.substring(i)+"\tERROR!");
						
						try {
							pw.close();
							bw.close();
							fw.close();
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						
						return;
					}
					else if (action.action == 'A')
					{
						pw.println(stack.toString()+"\t\t"+input.substring(i)+"\tACCEPT");
						
						try {
							pw.close();
							bw.close();
							fw.close();
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						
						return;
					}
					
					toWrite(i);
					
					if (action.action == 'S')
					{
						stack.push(input.substring(i, i+1));
						stack.push(Integer.toString(action.state));
					}
					else if (action.action == 'R')
					{
						i--;
						reduce();
					}
					
					i++;
				}
				else
				{
					if (input.charAt(i) == '+')
					{
						action.action = parseTable[gotoState][1].action;
						action.state = parseTable[gotoState][1].state;
					}
					else if (input.charAt(i) == '*')
					{
						action.action = parseTable[gotoState][2].action;
						action.state = parseTable[gotoState][2].state;
					}
					else if (input.charAt(i) == '(')
					{
						action.action = parseTable[gotoState][3].action;
						action.state = parseTable[gotoState][3].state;
					}
					else if (input.charAt(i) == ')')
					{
						action.action = parseTable[gotoState][4].action;
						action.state = parseTable[gotoState][4].state;
					}
					if (input.charAt(i) == '$')
					{
						action.action = parseTable[gotoState][5].action;
						action.state = parseTable[gotoState][5].state;
					}
					
					System.out.println(stack.toString()+"\t"+input.substring(i)+"\t"+(action.action+Integer.toString(action.state)));
					
					if (action.action == 'E')
					{
						pw.println(stack.toString()+"\t\t"+input.substring(i)+"\tERROR!");
						
						try {
							pw.close();
							bw.close();
							fw.close();
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						
						return;
					}
					else if (action.action == 'A')
					{
						pw.println(stack.toString()+"\t\t"+input.substring(i)+"\tACCEPT");
						
						try {
							pw.close();
							bw.close();
							fw.close();
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						
						return;
					}
					
					toWrite(i);
					
					if (action.action == 'S')
					{
						stack.push(Character.toString(input.charAt(i)));
						stack.push(Integer.toString(action.state));
					}
					else if (action.action == 'R')
					{
						i--;
						reduce();
					}
				}
				
				i++;
			}
		}
		
	
		try {
			pw.close();
			bw.close();
			fw.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}


public class Parser 
{	
	/**
	 * @param args
	 */
	public static void main(String[] args) 
	{
		ParsingAlgo obj = new ParsingAlgo();
		obj.defaultParseTable();
		obj.gui();
	}

}
