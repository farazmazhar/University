/// <summary>
/// Name: Faraz Mazhar
/// Roll: BCSF14M529
/// Subj: Enterprize Application Development
/// Assi: Grand HomeWork
/// </summary>


using System;
using System.Diagnostics;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Effects;
using System.Windows.Media.Imaging;
using System.Windows.Threading;

namespace PictureMatch
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    /// 
    
    public static class imageInitializer // This class initialzes Image controls with random images.
    {
        private static int[] instanceCount = {2, 2, 2, 2, 2, 2, 2, 2, 2}; // Each image is being placed twice.

        // This array contains path to every image.
        private static string[] path =
                {
                    @"images/GameContent/0.jpg",
                    @"images/GameContent/1.jpg",
                    @"images/GameContent/2.jpg",
                    @"images/GameContent/3.jpg",
                    @"images/GameContent/4.jpg",
                    @"images/GameContent/5.jpg",
                    @"images/GameContent/6.jpg",
                    @"images/GameContent/7.jpg",
                    @"images/GameContent/8.jpg",
                };

        private static Random rand = new Random(); // rand is used to generate a random number.
        

        public static void instanceCountInit() // Reinitalizes instance array for a new game.
        {
            for (int i = 0; i < 9; i++)
                instanceCount[i] = 2;
        }

        public static void imageInit(object sender) // This function initializes Image objects with pictures in random order.
        {

            // Formula to place images in random order.
            int picToSelect = ((((rand.Next() * rand.Next() % 9) % 9) + ((rand.Next() * rand.Next() % 9) % 9)) % 9);

            // Incase generated random number is a negative.
            if (picToSelect < 0)
                picToSelect *= -1;

            // Incase picture at generated index has been already placed twice.
            while (instanceCount[picToSelect] == 0)
            {
                picToSelect = ((picToSelect + rand.Next()) % 9); // Slightly adding more randomness.
            }

            // Placing images in random order.
            ((Image)sender).Source = new BitmapImage(new Uri(path[picToSelect], UriKind.Relative));
            instanceCount[picToSelect]--; // Decreases the number of instances left to be placed of the last placed image.
        }
    }

    public static class imageValidator // This class validates correct matches of images and tells if the game is finished or not.
    {
        public static Image[] selectedImage = new Image[2]; // Last two clicked images.
        public static object[] selectedButtons = new object[2]; // Last two clicked buttons.
        public static int imageValidCount = 0; // Number of valid image matches.

        public static bool isAllValid() // If all images have been validated.
        {
            return (imageValidCount == 9) ? true : false;
        }

        public static bool isImageValid()
        {

            // If last clicked images are valid, disable the buttons and return true else false.
            if (((selectedImage[0]).Source.ToString()).Equals((selectedImage[1]).Source.ToString()))
            {
                ((Button)selectedButtons[0]).IsEnabled = false;
                ((Button)selectedButtons[1]).IsEnabled = false;

                imageValidCount++;
                
                return true;
            }

            return false;
        }
    }

    public partial class MainWindow : Window
    {
        int clickCounter = 0; // Number of clicks to keep track of when to call imageValidator class.

        MediaPlayer mplayer = new MediaPlayer(); // mouse over sound.
        MediaPlayer correctsound = new MediaPlayer(); // correct image sound.
        MediaPlayer winsound = new MediaPlayer(); // If player wins the match.

        Stopwatch stopwatch = new Stopwatch(); // Stopwatch to keep track of time.
        private DispatcherTimer _timer; // Timer to update stopwatch in UI.

        public MainWindow()
        {
            InitializeComponent();

            // Initializing mouse over effects
            selectShadowInit();
            mediaPlayerInit();

            //mplayer.Play();

            seconds.Content = stopwatch.Elapsed.ToString("mm\\:ss");
            dispatcherInit();
            //MessageBox.Show(tileGrid.Children[0].ToString() + "\n" + new Button().ToString() + ": Button");
            setGame();

        }

        private void mediaPlayerInit() // Initiating audio with respective path.
        {
            mplayer.Open(new Uri(@"../../Sounds/mouseOver.mp3", UriKind.Relative));
            correctsound.Open(new Uri(@"../../Sounds/Bing-sound.mp3", UriKind.Relative));
            winsound.Open(new Uri(@"../../Sounds/fanfare.wav", UriKind.Relative));
        }

        private void stopwatchInit() // Sets stop watch to 0 and starts stopwatch.
        {
            stopwatch.Reset();
            stopwatch.Start();
        }

        private void dispatcherInit() // Timer to update 'time' on GUI.
        {
            _timer = new DispatcherTimer(DispatcherPriority.SystemIdle);
            _timer.Tick += new EventHandler(statusTimeElapsed);
            _timer.Interval = TimeSpan.FromMilliseconds(100);
            _timer.Start();
        }

        private void statusTimeElapsed(object sender, EventArgs e) // Placing 'time' in UI at Timer tick.
        {
            seconds.Content = stopwatch.Elapsed.ToString("mm\\:ss");
        }

        private void counterIterator() // Iterates counter, hides buttons and displays images.
        {
            correctsound.Stop(); // Brings correct image sound to 0 mark.
            winsound.Stop(); // Brings win sound to 0 mark

            clickCounter++; // Iterates counter.

            if (clickCounter > 0) // If player has clicked on a button at least once.
            {
                if (!stopwatch.IsRunning) // If stopwatch isn't running,
                    stopwatchInit();      // start stopwatch.

                button.Visibility = Visibility.Visible; // Displays new game button.

                if (clickCounter % 2 == 0) // If two buttons have been clicked...
                {
                    if (imageValidator.isImageValid()) // If last two clicked images are valid...
                    {
                        if (imageValidator.isAllValid()) // If all iamges are valid...
                        {
                            stopwatch.Stop(); // Stop stopwatch.
                            winsound.Play(); // Play win sound.
                            MessageBox.Show("Time taken: " + stopwatch.Elapsed.ToString("mm\\:ss")); // Show Message box with time taken to finish.
                            setGame(); // Reset the game.
                        }
                        else
                        {
                            correctsound.Play(); // If game is not finished but correct two images have been selected.
                        }
                    }
                    else // Incase of wrong selection of last two clicked images.
                    {
                        buttonTempDisabler(); // Disable all iamges.
                        var timer = new DispatcherTimer { Interval = TimeSpan.FromSeconds(1) }; // Disable for 1 sec.
                        timer.Start(); // Start timer
                        timer.Tick += (sender, args) =>
                        {
                            timer.Stop(); // Stop timer.
                            buttonTempEnabler(); // Reenable all buttons.
                        };
                    }
                }
                
            }

            
        }

        private void buttonTempDisabler() // Hides all the buttons.
        {
            int intTotalChildren = tileGrid.Children.Count - 1;
            for (int intCounter = intTotalChildren; intCounter >= 0; intCounter--)
            {
                if (tileGrid.Children[intCounter].ToString().Contains(new Button().ToString()))
                {
                    tileGrid.Children[intCounter].Visibility = Visibility.Hidden;
                }
            }
        }

        private void buttonTempEnabler() // Unhide all the buttons enabled buttons and hide all the images.
        {
            int intTotalChildren = tileGrid.Children.Count - 1;
            for (int intCounter = intTotalChildren; intCounter >= 0; intCounter--)
            {
                if (tileGrid.Children[intCounter].ToString().Contains(new Button().ToString()))
                {
                    if (tileGrid.Children[intCounter].IsEnabled)
                    {
                        tileGrid.Children[intCounter].Visibility = Visibility.Visible;
                        tileGrid.Children[intCounter - 18].Visibility = Visibility.Hidden;
                    }
                }
            }
        }

        private void setGame() // Set initial state of a game.
        {
            imageInitializer.instanceCountInit(); // Initialize image instance count.
            imageValidator.imageValidCount = 0; // Valid image count to 0.

            button.Visibility = Visibility.Hidden; // Hide new game button.

            imageInit(); // Place images on all the Iamge controls randomly.
            imageCollapserInit(); // Hide all the images.
            buttonVisible(); // Unhide all the buttons.

            clickCounter = 0; // Click count to 0.

            stopwatch.Reset(); // Take stop watch to 0sec mark.
        }

        private void imageInit() // Places images in the Image controls.
        {
            try
            {
                imageInitializer.imageInit(one_image);
                imageInitializer.imageInit(two_image);
                imageInitializer.imageInit(three_image);
                imageInitializer.imageInit(four_image);
                imageInitializer.imageInit(five_image);
                imageInitializer.imageInit(six_image);
                imageInitializer.imageInit(seven_image);
                imageInitializer.imageInit(eight_image);
                imageInitializer.imageInit(nine_image);
                imageInitializer.imageInit(ten_image);
                imageInitializer.imageInit(eleven_image);
                imageInitializer.imageInit(twelve_image);
                imageInitializer.imageInit(thirteen_image);
                imageInitializer.imageInit(fourteen_image);
                imageInitializer.imageInit(fifteen_image);
                imageInitializer.imageInit(sixteen_image);
                imageInitializer.imageInit(seventeen_image);
                imageInitializer.imageInit(eighteen_image);
            }
            catch (Exception e)
            {
                MessageBox.Show(e.StackTrace);
                MessageBox.Show(e.Message);
            }
        }

        private void selectShadowInit() // Adds shadow effect method to button methods.
        {
            int intTotalChildren = tileGrid.Children.Count - 1;
            for (int intCounter = intTotalChildren; intCounter >= 0; intCounter--)
            {
                if (tileGrid.Children[intCounter].ToString().Contains(new Button().ToString()))
                {
                    tileGrid.Children[intCounter].MouseEnter += userMouseEnter;
                    tileGrid.Children[intCounter].MouseLeave += userMouseLeave;
                }
            }
        }

        private void buttonVisible() // Makes all the button visible and enable them.
        {
            int intTotalChildren = tileGrid.Children.Count - 1;
            for (int intCounter = intTotalChildren; intCounter >= 0; intCounter--)
            {
                if (tileGrid.Children[intCounter].ToString().Contains(new Button().ToString()))
                {
                    tileGrid.Children[intCounter].IsEnabled = true;
                    tileGrid.Children[intCounter].Visibility = Visibility.Visible;
                }
            }
        }

        private void imageCollapserInit() // Hides all the images.
        {
            int intTotalChildren = tileGrid.Children.Count - 1;
            for (int intCounter = intTotalChildren; intCounter >= 0; intCounter--)
            {
                if (tileGrid.Children[intCounter].ToString().Equals(new Image().ToString()))
                {
                    tileGrid.Children[intCounter].Visibility = Visibility.Hidden;
                }
            }
        }

        private void imageFinal() // Makes all images visible.
        {
            int intTotalChildren = tileGrid.Children.Count - 1;
            for (int intCounter = intTotalChildren; intCounter >= 0; intCounter--)
            {
                if (tileGrid.Children[intCounter].ToString().Equals(new Image().ToString()))
                {
                    tileGrid.Children[intCounter].Visibility = Visibility.Visible;
                }
            }
        }

        private void userMouseEnter(object sender, MouseEventArgs e)
        {
            mplayer.Play();
            DropShadowEffect myDropShadowEffect = new DropShadowEffect();
            // Set the color of the shadow to Black.
            Color myShadowColor = new Color();
            myShadowColor.ScA = 1;
            myShadowColor.ScB = 0;
            myShadowColor.ScG = 0;
            myShadowColor.ScR = 0;
            myDropShadowEffect.Color = myShadowColor;

            // Set the direction of where the shadow is cast to 320 degrees.
            myDropShadowEffect.Direction = 320;

            // Set the depth of the shadow being cast.
            myDropShadowEffect.ShadowDepth = 5;
            
            // Set the shadow opacity to half opaque or in other words - half transparent.
            // The range is 0-1.
            myDropShadowEffect.Opacity = 0.5;

            // Apply the bitmap effect to the Button.
            ((Button)sender).Effect = myDropShadowEffect;
        } // Adds shadow effects on mouse enter.

        private void userMouseLeave(object sender, MouseEventArgs e)
        {
            mplayer.Stop();
            ((Button)sender).Effect = null;
        } // Removes shadow effect on mouse leave.

        private void button_Click(object sender, RoutedEventArgs e)
        {
            setGame();
        } // New game button.

        // Logic of all the buttons.

        private void one_Click(object sender, RoutedEventArgs e)
        {
            one.Visibility = Visibility.Collapsed;
            one_image.Visibility = Visibility.Visible;
            imageValidator.selectedButtons[(clickCounter % 2)] = one;
            imageValidator.selectedImage[(clickCounter % 2)] = one_image;
            counterIterator();
        }

        private void two_Click(object sender, RoutedEventArgs e)
        {
            two.Visibility = Visibility.Collapsed;
            two_image.Visibility = Visibility.Visible;
            imageValidator.selectedButtons[clickCounter % 2] = two;
            imageValidator.selectedImage[clickCounter % 2] = two_image;
            counterIterator();
        }

        private void three_Click(object sender, RoutedEventArgs e)
        {
            three.Visibility = Visibility.Collapsed;
            three_image.Visibility = Visibility.Visible;
            imageValidator.selectedButtons[clickCounter % 2] = three;
            imageValidator.selectedImage[clickCounter % 2] = three_image;
            counterIterator();
        }

        private void ten_Click(object sender, RoutedEventArgs e)
        {
            ten.Visibility = Visibility.Collapsed;
            ten_image.Visibility = Visibility.Visible;
            imageValidator.selectedButtons[clickCounter % 2] = ten;
            imageValidator.selectedImage[clickCounter % 2] = ten_image;
            counterIterator();
        }

        private void thirteen_Click(object sender, RoutedEventArgs e)
        {
            thirteen.Visibility = Visibility.Collapsed;
            thirteen_image.Visibility = Visibility.Visible;
            imageValidator.selectedButtons[clickCounter % 2] = thirteen;
            imageValidator.selectedImage[clickCounter % 2] = thirteen_image;
            counterIterator();
        }

        private void sixteen_Click(object sender, RoutedEventArgs e)
        {
            sixteen.Visibility = Visibility.Collapsed;
            sixteen_image.Visibility = Visibility.Visible;
            imageValidator.selectedButtons[clickCounter % 2] = sixteen;
            imageValidator.selectedImage[clickCounter % 2] = sixteen_image;
            counterIterator();
        }

        private void four_Click(object sender, RoutedEventArgs e)
        {
            four.Visibility = Visibility.Collapsed;
            four_image.Visibility = Visibility.Visible;
            imageValidator.selectedButtons[clickCounter % 2] = four;
            imageValidator.selectedImage[clickCounter % 2] = four_image;
            counterIterator();
        }

        private void six_Click(object sender, RoutedEventArgs e)
        {
            six.Visibility = Visibility.Collapsed;
            six_image.Visibility = Visibility.Visible;
            imageValidator.selectedButtons[clickCounter % 2] = six;
            imageValidator.selectedImage[clickCounter % 2] = six_image;
            counterIterator();
        }

        private void eight_Click(object sender, RoutedEventArgs e)
        {
            eight.Visibility = Visibility.Collapsed;
            eight_image.Visibility = Visibility.Visible;
            imageValidator.selectedButtons[clickCounter % 2] = eight;
            imageValidator.selectedImage[clickCounter % 2] = eight_image;
            counterIterator();
        }

        private void eleven_Click(object sender, RoutedEventArgs e)
        {
            eleven.Visibility = Visibility.Collapsed;
            eleven_image.Visibility = Visibility.Visible;
            imageValidator.selectedButtons[clickCounter % 2] = eleven;
            imageValidator.selectedImage[clickCounter % 2] = eleven_image;
            counterIterator();
        }

        private void fourteen_Click(object sender, RoutedEventArgs e)
        {
            fourteen.Visibility = Visibility.Collapsed;
            fourteen_image.Visibility = Visibility.Visible;
            imageValidator.selectedButtons[clickCounter % 2] = fourteen;
            imageValidator.selectedImage[clickCounter % 2] = fourteen_image;
            counterIterator();
        }

        private void seventeen_Click(object sender, RoutedEventArgs e)
        {
            seventeen.Visibility = Visibility.Collapsed;
            seventeen_image.Visibility = Visibility.Visible;
            imageValidator.selectedButtons[clickCounter % 2] = seventeen;
            imageValidator.selectedImage[clickCounter % 2] = seventeen_image;
            counterIterator();
        }

        private void five_Click(object sender, RoutedEventArgs e)
        {
            five.Visibility = Visibility.Collapsed;
            five_image.Visibility = Visibility.Visible;
            imageValidator.selectedButtons[clickCounter % 2] = five;
            imageValidator.selectedImage[clickCounter % 2] = five_image;
            counterIterator();
        }

        private void seven_Click(object sender, RoutedEventArgs e)
        {
            seven.Visibility = Visibility.Collapsed;
            seven_image.Visibility = Visibility.Visible;
            imageValidator.selectedButtons[clickCounter % 2] = seven;
            imageValidator.selectedImage[clickCounter % 2] = seven_image;
            counterIterator();
        }

        private void nine_Click(object sender, RoutedEventArgs e)
        {
            nine.Visibility = Visibility.Collapsed;
            nine_image.Visibility = Visibility.Visible;
            imageValidator.selectedButtons[clickCounter % 2] = nine;
            imageValidator.selectedImage[clickCounter % 2] = nine_image;
            counterIterator();
        }

        private void twelve_Click(object sender, RoutedEventArgs e)
        {
            twelve.Visibility = Visibility.Collapsed;
            twelve_image.Visibility = Visibility.Visible;
            imageValidator.selectedButtons[clickCounter % 2] = twelve;
            imageValidator.selectedImage[clickCounter % 2] = twelve_image;
            counterIterator();
        }

        private void fifteen_Click(object sender, RoutedEventArgs e)
        {
            fifteen.Visibility = Visibility.Collapsed;
            fifteen_image.Visibility = Visibility.Visible;
            imageValidator.selectedButtons[clickCounter % 2] = fifteen;
            imageValidator.selectedImage[clickCounter % 2] = fifteen_image;
            counterIterator();
        }

        private void eighteen_Click(object sender, RoutedEventArgs e)
        {
            eighteen.Visibility = Visibility.Collapsed;
            eighteen_image.Visibility = Visibility.Visible;
            imageValidator.selectedButtons[clickCounter % 2] = eighteen;
            imageValidator.selectedImage[clickCounter % 2] = eighteen_image;
            counterIterator();
        }
    }
}