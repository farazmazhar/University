   M S B A M L   `   `   `  ����K  GdynamicTicTacToe, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null3clr-namespace:dynamicTicTacToedynamicTicTacToe  5   	   !    dynamicTicTacToe.MainWindow   5   	   \ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    5   	   R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	   @d2http://schemas.microsoft.com/expression/blend/2008     5   	   Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5   	   0localclr-namespace:dynamicTicTacToe     5   	     � Title$  World's best tic-tac-toe��5   	   $	��650��6*   $	��550��67   .��5	      � .+�5
   
   � -   5         �Name$ mainGrid��5
      $��70,200,70,70q�6!   � 5   
   $��
70,70,70,0q�6   $��68��6#   $	��Top=�6/    � ColumnDefinitions 5      �� 5      $	��67* �6#   �� 5      $	��67* �6#   �� 5      $��33.5* �6#   �� 5      $��33.5* �6#    � RowDefinitions 5      �� 5      $��8* �6    �� 5      $	��11* �6    �� 5      $	��11* �6    .+�5      �� -   5         ��Name$
 size��5      $��1��6$    �� TextWrapping$
 Wrap=�61   $��3��6E   $��16(�6N   $��0,0,81,0q�6\   $
��Bold"�6n    �� TextAlignment$ Center=�6�   �� 5      -   5         ��Name$ setSize��5      $��Start/Restart��6&   $��1��6>   $��Right=�6^   $��78��6z   �� 5      -   5         ��Name$
 xbox��5      $	��X: ��6&   $��2��61   $��1��6A   $��2��6N   $
��Wrap=�6_   $��16(�6s   $��0,0,0,24q�6�   �� 5      -   5        $
 ybox��5      $	��Y: ��6&   $��3��61   $
��Wrap=�6A   $��16(�6U   $��0,0,1,0q�6c   $��1��6t   �� 5      -   5        $ turnDisplay��5      $��1��6-   $��0,0,0,-1q�6=   $��2��6O   $
��Wrap=�6\   $��Turn?��6p   $
��Bold"�6}   $��14(�6�   	 �� TextAlignment$	 Center=�6�   �� 5      -   5        $ reset��5      $��Reset��6$   $��29.5,0,29.5,0q�64   $��1��6K   $��1��6[   6h   5      5      5       