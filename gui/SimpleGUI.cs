// SimpleGUI.cs
using System;
using System.Windows.Forms;

namespace PinguOS
{
    public class SimpleGUI : Form
    {
        public SimpleGUI()
        {
            Text = "Pingu OS";
            Width = 800;
            Height = 600;

            Button btn = new Button();
            btn.Text = "Click Me!";
            btn.Top = 100;
            btn.Left = 100;
            btn.Click += (sender, e) => MessageBox.Show("Welcome to Pingu OS 64-bit!");

            TextBox txtBox = new TextBox();
            txtBox.Top = 200;
            txtBox.Left = 100;
            txtBox.Width = 200;

            Controls.Add(btn);
            Controls.Add(txtBox);
        }

        [STAThread]
        public static void Main()
        {
            Application.Run(new SimpleGUI());
        }
    }
}
