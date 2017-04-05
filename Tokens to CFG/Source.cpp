/// Name: Faraz Mazhar
/// Roll: BCSF14M529
/// Subj: Compiler Construction
/// Assi: Tokens to CFG

#include <iostream>
#include <fstream>
#include <string>
#include <cstring>

using namespace std;

struct Tokens
{
	int lineNo;
	string codeWord;
	string token;
};

class TokenstoCFG
{
private:
	Tokens input_carry;
	ifstream ifs;
	ofstream ofs;
	string output;

	int place;
	bool isValid;
	bool nextLine;
	int currentLine;
	bool discard;
	bool isReduntantErr;
	bool eof;

public:
	TokenstoCFG(string filename)
	{
		input_carry.lineNo = 0;
		input_carry.codeWord = "";
		input_carry.token = "";

		isValid = false;
		nextLine = true;
		discard = false;
		isReduntantErr = false;
		eof = false;
		currentLine = 0;

		ifs.open(filename+"_tokens.lexical");
		ofs.open(filename+"_validity.cfg");
	}

	~TokenstoCFG()
	{
		ifs.close();
	}

	void getNext()
	{
		discard = false;

		ifs >> input_carry.lineNo >> input_carry.codeWord >> input_carry.token;

		cout << input_carry.lineNo << " " << currentLine << " " <<  endl;

		if (nextLine == true)
		{
			if (currentLine != input_carry.lineNo)
			{
				currentLine = input_carry.lineNo;
				nextLine = false;
				discard = false;
				isReduntantErr = false;
			}
			else
			{
				if (isReduntantErr == false)
				{
					output = ("Invalid stream.-2");
					isReduntantErr = true;
				}

				cout << input_carry.lineNo << "testtest" << endl;

				discard = true;
			}
		}
		else if (nextLine == false)
		{
			if (currentLine == input_carry.lineNo)
			{
				discard = false;
				isReduntantErr = false;
			}
			else
			{
				discard = true;
			}
		}
	}

	int whichKeyword()
	{
		if (input_carry.token == "keyword")
		{
			if (input_carry.codeWord == "int")
			{
				return 1;
			}
			else if (input_carry.codeWord == "float")
			{
				return 2;
			}
		}

		return 0; // if not a keyword.
	}

	bool isID()
	{
		if (input_carry.token == "ID")
		{
			return true;
		}

		return false;
	}

	int opCheck()
	{
		if (input_carry.token == "=")
		{
			return 1;
		}
		else if (input_carry.token == "==")
		{
			return 2;
		}
		else if (input_carry.token == ",")
		{
			return 3;
		}
		else if (input_carry.token == ";")
		{
			return 4;
		}
		else
		{
			return 0;
		}
	}

	int constCheck()
	{
		if (input_carry.token == "int")
		{
			return 1;
		}
		else if (input_carry.token == "float")
		{
			return 2;
		}
		
		return 0; // if not a constant.
	}

	void CFGvalidity()
	{
		int kw = whichKeyword();

		cout << input_carry.token << " " << input_carry.codeWord << " " << kw << endl;

		if (kw > 0)
		{
			place = ifs.tellg();
			getNext();

			if (discard)
			{
				ifs.seekg(place);
				ofs << (input_carry.lineNo - 1) << "\t" << ("Invalid stream: Next line was not expected.3") << endl;
				nextLine = true;
				return;
			}

			if (isID())
			{
				place = ifs.tellg();
				getNext();

				if (discard)
				{
					ofs << (input_carry.lineNo - 1) << "\t" << ("Invalid stream: Next line was not expected.2") << endl;
					ifs.seekg(place);
					nextLine = true;
					return;
				}

				if (opCheck() == 1)
				{
					place = ifs.tellg();
					getNext();

					if (discard)
					{
						ofs << (input_carry.lineNo - 1) << "\t" << ("Invalid stream: Next line was not expected.1") << endl;
						ifs.seekg(place);
						nextLine = true;
						return;
					}

					if (constCheck() == kw)
					{
						place = ifs.tellg();
						getNext();

						if (discard)
						{
							ofs << (input_carry.lineNo - 1) << "\t" << ("Invalid stream: Next line was not expected.") << endl;
							ifs.seekg(place);
							nextLine = true;
							return;
						}

						if (opCheck() == 4)
						{
							
							output = ("Valid stream.");
							isValid = true;
							nextLine = true;
						}
						else
						{
							output = ("Invalid stream: Current line is missing \';\'.");
							nextLine = true;
							return;
						}
					}
					else
					{
						output = ("Invalid stream: A valid const is expected.");
						nextLine = true;
						return;
					}
				}
				else
				{
					output = ("Invalid stream: An operator is missing.");
					nextLine = true;
					return;
				}
			}
			else
			{
				output = ("Invalid stream: An identifer expected.");
				nextLine = true;
				return;
			}
		}
		else if (kw == 0)
		{
			if (isID())
			{
				place = ifs.tellg();
				getNext();

				if (discard)
				{
					ofs << (input_carry.lineNo - 1) << "\t" << ("Invalid stream: Next line was not expected.") << endl;
					ifs.seekg(place);
					nextLine = true;
					return;
				}

				if (opCheck() == 1)
				{
					place = ifs.tellg();
					getNext();

					if (discard)
					{
						ofs << (input_carry.lineNo - 1) << "\t" << ("Invalid stream: Next line was not expected.") << endl;
						ifs.seekg(place);
						nextLine = true;
						return;
					}

					if (constCheck() > 0)
					{
						place = ifs.tellg();
						getNext();

						if (discard)
						{
							ofs << (input_carry.lineNo - 1) << "\t" << ("Invalid stream: Next line was not expected.") << endl;
							ifs.seekg(place);
							nextLine = true;
							return;
						}

						if (opCheck() == 4)
						{
							output = ("Valid stream.");
							isValid = true;
							nextLine = true;
						}
						else
						{
							output = ("Invalid stream: An operator is missing; probably \';\'.");
							nextLine = true;
							return;
						}
					}
					else
					{
						output = ("Invalid stream: A valid const missing.");
						nextLine = true;
						return;
					}
				}
				else
				{
					output = ("Invalid stream: Missing operator.");
					nextLine = true;
					return;
				}

			}
			else
			{
				output = ("Invalid stream: Identifier expected.1");
				nextLine = true;
				return;
			}
		}
	}

	void operation()
	{
		getNext();
		
		cout << input_carry.lineNo << " Outside the loop" << endl;

		do
		{
			cout << input_carry.lineNo << " inside the loop" << endl;
			CFGvalidity();

			if (!discard)
				ofs << input_carry.lineNo << "\t" << output << endl;

			getNext();

		} while (input_carry.lineNo != 0);
	}
};

void main()
{
	string filename = "Source";

	TokenstoCFG obj(filename);
	obj.operation();

	cout << "CFG validated. Please check the " + filename + "_validity.cfg." << endl;
}