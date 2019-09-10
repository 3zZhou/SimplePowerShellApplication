Add-Type -assembly System.Windows.Forms

Function MakeNewForm {    
	$main_form.Close()
	$main_form.Dispose()
	MakeForm
}

Function MakeForm {
    # create new form
    $main_form = New-Object System.Windows.Forms.Form
    $main_form.Text ='BitTitan App'
    $main_form.Width = 600
    $main_form.Height = 400
    $main_form.AutoSize = $true

    # create new user
    $UserNameLabel = New-Object System.Windows.Forms.Label
    $UserNameLabel.Text = "User Name: "
    $UserNameLabel.Location = New-Object System.Drawing.Point (0, 10)
    $UserNameLabel.AutoSize = $true
    $main_form.Controls.Add($UserNameLabel)
    
    $UserNameTextBox = New-Object System.Windows.Forms.TextBox
    $UserNameTextBox.Location = New-Object System.Drawing.Point (150, 10)
    $main_form.Controls.Add($UserNameTextBox)
    
    $PasswordLabel = New-Object System.Windows.Forms.Label
    $PasswordLabel.Text = "Password: "
    $PasswordLabel.Location = New-Object System.Drawing.Point (0, 40)
    $PasswordLabel.AutoSize = $true
    $main_form.Controls.Add($PasswordLabel)
    
    $PasswordTextBox = New-Object System.Windows.Forms.MaskedTextBox
    $PasswordTextBox.Location = New-Object System.Drawing.Point (150, 40)
    $PasswordTextBox.PasswordChar = "*"
    $PasswordAsSecure = ConvertTo-SecureString -String $PasswordTextBox -AsPlainText -Force
    $main_form.Controls.Add($PasswordTextBox)
    
    $CreateButton = New-Object System.Windows.Forms.Button
    $CreateButton.Location = New-Object System.Drawing.Size(300,40)
    $CreateButton.Size = New-Object System.Drawing.Size(120,23)
    $CreateButton.Text = "Create User"
    $CreateButton.Add_Click(
    {
        if ([string]::IsNullOrEmpty($UserNameTextBox.Text)) {
            [System.Windows.Forms.MessageBox]::Show('The user name should not be blank', 'Warning', 'OK', 'Error')
        }
        else{
            New-LocalUser $UserNameTextBox.Text -Password $PasswordAsSecure -FullName $UserNameTextBox.Text
            MakeNewForm  
        }
    }
    )
    $main_form.Controls.Add($CreateButton)
    
    # Update user name
    $Users = Get-LocalUser
    $UsersCount = New-Object System.Windows.Forms.Label
    $UsersCount.Text = "Users count is " + $Users.Count
    $UsersCount.Location  = New-Object System.Drawing.Point(0,100)
    $UsersCount.AutoSize = $true
    $main_form.Controls.Add($UsersCount)
    
    $UserComboBox = New-Object System.Windows.Forms.ComboBox
    $UserComboBox.Width = 300
    Foreach ($User in $Users)
    {
    $UserComboBox.Items.Add($User.Name);
    }
    $UserComboBox.Location  = New-Object System.Drawing.Point(0,130)
    $main_form.Controls.Add($UserComboBox)
    
    $NewUserNameLabel = New-Object System.Windows.Forms.Label
    $NewUserNameLabel.Text = "New User Name: "
    $NewUserNameLabel.Location = New-Object System.Drawing.Point (0, 160)
    $NewUserNameLabel.AutoSize = $true
    $main_form.Controls.Add($NewUserNameLabel)
    
    $NewUserName = New-Object System.Windows.Forms.TextBox
    $NewUserName.Location = New-Object System.Drawing.Point (150, 160)
    $main_form.Controls.Add($NewUserName)
    
    $UpdateButton = New-Object System.Windows.Forms.Button
    $UpdateButton.Location = New-Object System.Drawing.Size(300,160)
    $UpdateButton.Size = New-Object System.Drawing.Size(200,23)
    $UpdateButton.Text = "Update User Name"
    $UpdateButton.Add_Click(
    {
        if ([string]::IsNullOrEmpty($NewUserName.Text)) {
            [System.Windows.Forms.MessageBox]::Show('The new user name should not be blank', 'Warning', 'OK', 'Error')
        }
        else{
            Rename-LocalUser -Name $UserComboBox.SelectedItem -NewName $NewUserName.Text
            MakeNewForm
        }        
    }
    )
    $main_form.Controls.Add($UpdateButton)
    
    
    # Delete user
    $DeleteButton = New-Object System.Windows.Forms.Button
    $DeleteButton.Location = New-Object System.Drawing.Size(300,190)
    $DeleteButton.Size = New-Object System.Drawing.Size(200,23)
    $DeleteButton.Text = "Delete Seleted User"
    $DeleteButton.Add_Click(
    {
        if ([string]::IsNullOrEmpty($UserComboBox.SelectedItem)) {
            [System.Windows.Forms.MessageBox]::Show('Please select a user to delete', 'Warning', 'OK', 'Error')
        }
        else{
            Remove-LocalUser -Name $UserComboBox.SelectedItem
            MakeNewForm
        }        
    }
    )
    $main_form.Controls.Add($DeleteButton)
    
    $main_form.ShowDialog()
}

MakeForm

