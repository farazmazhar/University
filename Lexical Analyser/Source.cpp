// Name: Faraz Mazhar
// Roll: BCSF14M529
// Subj: Compiler Construction
// Assi: Lexical Analyser


//Including libraries.
#include <iostream>
#include <fstream>
#include <string>
#include <cstring>

using namespace std;

//Creating class for minimizing the clutter and for the ease of use in the future.

class LexicalAnalyser
{
private:
	int forward, lexeme_start, current_state, last_final_state; //Declaring variables.
	int index_while_final_state, state_visited; //Declaring variables.
	int lineNo; //To keep track of lines.
	string code_line; //This variable carries code line by line.
	string filename; //Carries file name of source code.
	ifstream fin; //File input stream
	ofstream fout; //File output stream

public:
	LexicalAnalyser(string filename) //Constructor
	{
		//Setting initial values.
		this->forward = 0;
		this->current_state = 0;
		this->lexeme_start = 0;
		this->last_final_state = -1;
		this->index_while_final_state = -1;
		this->lineNo = 0;
		this->filename = filename;

		//Opening files.
		this->fin.open(filename + ".dpp");
		this->fout.open(filename + "_tokens.lexical");
	}

	~LexicalAnalyser() //Destructor
	{
		fin.close();
		fout.close();
	}

	bool isAlphabet(char character) //Checks if the character is an alphabet or not.
	{
		if ((character >= 'A' && character <= 'Z') || (character >= 'a' && character <= 'z'))
		{
			return true;
		}

		return false;
	}

	bool isDigit(char character) //Checks if the character is a number or not.
	{
		if (character >= '0' && character <= '9')
			return true;

		return false;
	}

	int getState(int current_state, char character) //This function returns the state based on Finite Automata.
	{
		if (character == '\b' || character == ' ' || character == '\n') //Returning -2 so that ungetch() is called on these cases.
		{
			return -2;
		}

		switch (current_state)
		{
		case 0: //At state 0; not final
			if (character == '_' || isAlphabet(character))
			{
				return 1;
			}
			else if (character == '=')
			{
				return 2;
			}
			else if (isDigit(character))
			{
				return 4;
			}
			else if (character == ',')
			{
				return 7;
			}
			else if (character == ';')
			{
				return 8;
			}
			else if (character == '\b' || character == ' ' || character == '\n')
			{
				return 0;
			}
			else
			{
				return -2;
			}
			break;

		case 1: //At state 1
			if (character == '_' || isAlphabet(character))
			{
				return 1;
			}
			else
			{
				return -2;
			}
			break;

		case 2: //At state 2
			if (character == '=')
			{
				return 3;
			}
			else
			{
				return -2;
			}
			break;

		case 3: //At state 3
			return -2;
			break;

		case 4: //At state 4
			if (isDigit(character))
			{
				return 4;
			}

			if (character == '.')
			{
				return 5;
			}

			return -2;
			break;

		case 5: //At state 5; not final
			if (isDigit(character))
			{
				return 6;
			}
			else
			{
				return -2;
			}
			break;

		case 6: //At state 6
			if (isDigit(character))
			{
				return 6;
			}
			else
			{
				return -2;
			}
			break;

		case 7: //At state 7
			return -2;
			break;

		case 8: //At state 8
			return -2;
			break;

		default:
			return -2;
		}


		return -2;
	}


	void reset() //Resetting the values.
	{
		//forward = index_while_final_state + 1; // This was causing a logical error hence it was commented.
		lexeme_start = forward;
		current_state = 0;
		last_final_state = -1;
		index_while_final_state = -1;
	}

	void skip() //To skip when certain characters.
	{
		lexeme_start = forward;
	}

	string _ungetch() //This code will take a substirng from Lexeme start to Index while last final state visited.
	{
		if (code_line.substr(lexeme_start, 1) == " ")
		{
			lexeme_start++;
		}

		string get_string = code_line.substr(lexeme_start, (index_while_final_state - lexeme_start) + 1);
		return get_string;
	}

	bool isAKeyword(string get_string) //Checking for keywords.
	{
		if (get_string == "int" || get_string == "float")
		{
			return true;
		}
		return false;
	}

	void generateTokens(string code_substring) //This function is generating tokens in an output file.
	{
		cout << last_final_state << endl;

		if (last_final_state == 1) //Tokens for keywords and ID
		{
			if (isAKeyword(code_substring) == true)
			{
				fout << lineNo << '\t' << code_substring << '\t' << "keyword" << endl;
			}

			if (isAKeyword(code_substring) == false)
			{
				fout << lineNo << '\t' << code_substring << '\t' << "ID" << endl;
			}
		}

		if (last_final_state == 2) //Tokens for =
		{
			fout << lineNo << '\t' << code_substring << '\t' << "=" << endl;
		}

		if (last_final_state == 3) //Tokens for ==
		{
			fout << lineNo << '\t' << code_substring << '\t' << "==" << endl;
		}

		if (last_final_state == 4) //Tokens for integers
		{
			fout << lineNo << '\t' << code_substring << '\t' << "int" << endl;
		}

		if (last_final_state == 6) //Tokens for floats
		{
			fout << lineNo << '\t' << code_substring << '\t' << "float" << endl;
		}

		if (last_final_state == 7) //Tokens for ,
		{
			fout << lineNo << '\t' << code_substring << '\t' << "," << endl;
		}

		if (code_substring == ";") //Tokens for ;
		{
			fout << lineNo << '\t' << code_substring << '\t' << ";" << endl;
		}
	}

	char getforward(int forward) //Returns character at which forward is pointing.
	{
		return code_line[forward];
	}

	void lexical_analysisV2() //This function is where the magic happens.
	{
		char character;
		string carry;

		while (getline(fin, code_line)) //Reading lines from source code file of .dpp extension.
		{
			reset();
			forward = 0;
			lexeme_start = 0;
			lineNo++; //Counting lines.

			while (forward < code_line.length()) //Iterating the code line.
			{
				int state;

				state = getState(current_state, getforward(forward)); //Returns state.

				if (state == -2) //This check initiates token generations.
				{
					cout << lexeme_start << "  " << index_while_final_state << " " << forward << endl;
					carry = _ungetch();
					generateTokens(carry);

					reset();
				}

				if (state >= 0) //Setting states and index variables.
				{
					current_state = state;

					if (state != 0 && state != 5)
					{
						index_while_final_state = forward;
						last_final_state = current_state;
					}
				}

				if (forward == code_line.length() - 1) //Generation of tokens for the last part of code line.
				{
					carry = _ungetch();
					generateTokens(carry);
				}

				forward++; //Iterating.
			}
		}
		fout << 0;
	}
};




void main()
{
	string filename = "Source"; //File name goes here (without extension)
	LexicalAnalyser obj(filename); //Creating object.
	obj.lexical_analysisV2(); //Calling the analyser function.
	system("cls"); //Clearing screen.
	cout << "Tokens generated.\nOpen \"" + filename + "_tokens.lexical\" in text editor for inspection of generarted tokens." << endl; //Exit prompt.
}

/// <Known Issues>
/// There must be a space between variable name(ID), assignment operator(=) and the value(float or integer).
/// For example: "int var = 2;"
/// </>