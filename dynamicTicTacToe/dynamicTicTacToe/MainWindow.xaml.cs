/// <summary>
/// Name: Faraz Mazhar
/// Roll: BCSF14M529
/// Subj: Enterprize Application Development
/// Assi: Grand HomeWork
/// </summary>


using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;

namespace dynamicTicTacToe
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        MediaPlayer mouseclick = new MediaPlayer(); // Sound effect for a mouse click.
        MediaPlayer winsound = new MediaPlayer(); // Sound effect for a win.

        int n = 3; // Default value of size
        int x_wins = 0; // Number of games won by X.
        int o_wins = 0; // Number of games won by Y.
        int turn = 0; // Number of turns per game.
        int game = 0; // Number of games played.

        char[][] logicGrid; // This grid is where patterns are checked
        Button[][] button;

        public MainWindow()
        {
            InitializeComponent();

            scoreBoard();
            mediaInit();
        }

        private void scoreBoard()
        {
            xbox.Text = "X: " + x_wins.ToString();
            ybox.Text = "O: " + o_wins.ToString();
        } // Displays score.

        private void mediaInit()
        {
            mouseclick.Open(new Uri(@"../../Sounds/Bing-sound.mp3", UriKind.Relative));
            winsound.Open(new Uri(@"../../Sounds/fanfare.wav", UriKind.Relative));
        } // Sounds effect.


        /// <summary>
        /// Win logic inspired from:
        /// http://stackoverflow.com/questions/20578372/tictactoe-win-logic-for-nxn-board
        /// http://www.dreamincode.net/forums/topic/341163-n-x-n-gui-tictactoe-game-winning-algorithm/
        /// 
        /// Win logic:
        /// Adding all the instances of either X or O and then check their sum
        /// with ascii * n.
        /// 
        /// </summary>
        /// <returns></returns>

        private bool winLogic(char toCheck) // Takes a char to check.
        {
            int total = 0;

            for (int row = 0; row < n; row++) // horizontal check.
            {
                total = 0;
                for (int col = 0; col < n; col++)
                {
                    total += logicGrid[row][col];
                }

                if (total == toCheck * n)
                {
                    return true;
                }
            }

            for (int col = 0; col < n; col++) // Vertical check.
            {
                total = 0;
                for (int row = 0; row < n; row++)
                {
                    total += logicGrid[row][col];
                }

                if (total == toCheck * n)
                {
                    return true;
                }
            }

            total = 0;
            for (int diag = 0; diag < n; diag++) // Diagonal one check
            {
                total += logicGrid[diag][diag];
            }

            if (total == (toCheck * n))
            {
                return true;
            }

            total = 0;
            for (int diagInvrt = 0; diagInvrt < n; diagInvrt++) // Diagonal two check
            {
                total += logicGrid[diagInvrt][n - diagInvrt - 1];
            }

            if (total == (toCheck * n))
            {
                return true;
            }

            return false;
        }

        private void start_game(object sender, RoutedEventArgs e) // Initializes variables.
        {
            x_wins = 0;
            o_wins = 0;
            turn = 0;
            game = 0;

            setSize_Click(sender, e); // Creats the grid and places buttons
        }

        private void setSize_Click(object sender, RoutedEventArgs e)
        {
            GC.Collect(); // Grabage collector.
            scoreBoard(); // Displays scoreboard

            //Following check is performed to alternate turns between X and O.
            if (game % 2 == 0)
            {
                turnDisplay.Text = "X goes first!";
            }
            else if(game % 2 == 1)
            {
                turnDisplay.Text = "0 goes first!";
            }

            turn = 0;

            // Check input for size
            if (!(int.TryParse(size.Text, out n))) // If value is not integer.
            {
                size.Text = "Invalid";
                MessageBox.Show("'"+size.Text + "' is an invalid input.");
                size.Text = "3";
            }
            else if (n < 3) // If value is less than 2.
            {
                size.Text = "Invalid";
                MessageBox.Show("Size must be greater than or equal to 3.");
                size.Text = "3";
            }
            else // If value is valid.
            {
                mainGrid.ColumnDefinitions.Clear(); // Removes previous columns.
                mainGrid.RowDefinitions.Clear(); // Removes previous rows.

                ColumnDefinition[] col = new ColumnDefinition[n]; // Creates columns.
                RowDefinition[] row = new RowDefinition[n]; // Creates rows.
                
                for (int i = 0; i < n; i++)
                {
                    col[i] = new ColumnDefinition(); // Initialzing columns.
                    row[i] = new RowDefinition(); // Initializing rows.

                    mainGrid.ColumnDefinitions.Add(col[i]); // Adding columns to the grid.
                    mainGrid.RowDefinitions.Add(row[i]); // Adding rows to the grid.
                }

                button = new Button[n][]; // Creates column button controls.
                logicGrid = new char[n][]; // Creates a logical grid for finding out winner.

                for (int i = 0; i < n; i++)
                {
                    button[i] = new Button[n]; // Creating row button controls.
                    logicGrid[i] = new char[n];
                }

                for (int i = 0; i < n; i++) // 'i' is column
                {
                    for (int j = 0; j < n; j++) // 'j' is row
                    {
                        button[i][j] = new Button(); // Initialzing button controls.
                        button[i][j].Click += setValue; // Sets click property of button controls.
                        button[i][j].Uid = i.ToString()+","+j.ToString(); // Sets uid
                        button[i][j].Content = " "; // Initialzes content.

                        Grid.SetColumn(button[i][j], i); // Sets row for button.
                        Grid.SetRow(button[i][j], j);  // Sets column for button.

                        mainGrid.Children.Add(button[i][j]); // Adds button to grid.
                    }
                }
            }
        }

        private void setValue(object sender, RoutedEventArgs e)
        {
            mouseclick.Stop(); // Takes audio clip to 0sec mark.
            mouseclick.Play(); // Plays audio clip.

            int row, col;
            string[] coordinates = ((Button)sender).Uid.Split(','); // Splits coordinate from uid.
            

            col = int.Parse(coordinates[0]); // Col.
            row = int.Parse(coordinates[1]); // Row.

            if (turn % 2 == game % 2) // Checks if either X or O gets to go first.
            {
                ((Button)sender).Content = "X"; // Set content of button control.
                logicGrid[col][row] = 'X'; // Set grid.
            }
            else
            {
                ((Button)sender).Content = "O"; // Set content of button control.
                logicGrid[col][row] = 'O'; // Set grid.
            }

            ((Button)sender).IsEnabled = false; // Disables clicked buttons.

            turn++; // Increments turn.

            if (winLogic('X')) // Checks for win condition of X. 
            {
                winsound.Stop();
                winsound.Play(); // Plays win audio.

                game++; // Increments number of games played.
                x_wins++; // Increments X wins.
                MessageBox.Show("X wins!"); // Displays X wins message.
                setSize_Click(null, null); // Resets the game.
            }
            else if (winLogic('O')) // Checks for win condition of Y.
            {
                winsound.Stop();
                winsound.Play(); // Plays win audio.

                game++; // Increments number of games played.
                o_wins++; // Increments O wins.
                MessageBox.Show("O wins!"); // Displays O wins message.
                setSize_Click(null, null); // Resets the game.
            }

            if (turn == (n * n)) // Draw case.
            {
                MessageBox.Show("Draw!"); // Displays draw message.
                setSize_Click(null, null); // Resets the game.
            }
        }
    }
}