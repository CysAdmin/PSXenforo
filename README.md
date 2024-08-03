## PSXenforo
This module provides cmdlets to interact with the Xenforo API, enabling you to manage various aspects of your Xenforo forum from the command line

## Contribution
Contributions are welcome! Please fork the repository and submit a pull request.

## Installation
To install the Xenforo PowerShell Module, you can use the following command:

```powershell
# Clone the repository
git clone https://github.com/CysAdmin/PSXenforo

# Navigate to the module directory
cd PSXenforo

# Import the module
Import-Module -Name PSXenforo
```

## Overview
The Xenforo PowerShell Module includes the following cmdlets:

- **Add-XenforoAlert**: Adds a new alert to a Xenforo user.
- **Add-XenforoPost**: Adds a new post to an existing thread in Xenforo.
- **Add-XenforoThread**: Creates a new thread in a Xenforo forum.
- **Add-XenforoUser**: Adds a new user to Xenforo.
- **Connect-XenforoApi**: Establishes a connection to the Xenforo API.
- **Get-XenforoAlerts**: Retrieves alerts for a Xenforo user.
- **Get-XenforoForum**: Retrieves information about a Xenforo forum.
- **Get-XenforoNodes**: Retrieves information about nodes in Xenforo.
- **Get-XenforoPost**: Retrieves information about a specific post in Xenforo.
- **Get-XenforoThreads**: Retrieves threads from a Xenforo forum.
- **Get-XenforoUsers**: Retrieves information about users in Xenforo.
- **Set-XenforoThreadRead**: Marks a thread as read for a user in Xenforo.




## Add-XenforoAlert

### Synopsis
Adds a new alert to a Xenforo user.

### Syntax
```powershell
Add-XenforoAlert [-ToUserId] <int> [-Content] <string> [-FromUserId] <string> [<CommonParameters>]
Add-XenforoAlert -ToUserId 123 -Content "This is an alert message" -FromUserId "456"
```

## Add-XenforoPost

### Synopsis
Adds a new post to an existing thread in Xenforo.

### Syntax
```powershell
Add-XenforoPost [-ThreadId] <int> [-Content] <string> [-UserId] <string> [<CommonParameters>]
Add-XenforoPost -ThreadId 456 -Content "This is a new post content" -UserId "123"
```

## Add-XenforoThread

### Synopsis
Creates a new thread in a Xenforo forum.

### Syntax
```powershell
Add-XenforoThread [-NodeId] <int> [-Content] <string> [-Title] <string> [-UserId] <string> [<CommonParameters>]
Add-XenforoThread -NodeId 789 -Title "New Discussion Thread" -Content "This is the first post in the new thread" -UserId "456"
```

## Add-XenforoUser

### Synopsis
Adds a new user to Xenforo.

### Syntax
```powershell
Add-XenforoUser [-Username] <string> [-EmailAddress] <string> [-Password] <string> [<CommonParameters>]
Add-XenforoUser -Username "newuser" -EmailAddress "newuser@example.com" -Password "SecurePassword123"
```

## Connect-XenforoApi

### Synopsis
Connects to the XenForo API.

### Description
The `Connect-XenforoApi` function establishes a connection to the XenForo API using the provided API key and base URL. It validates the connection by making a test request to the API and returns details about the connection.

### Syntax
```powershell
Connect-XenforoApi [-ApiKey] <string> [-ApiUrl] <string> [<CommonParameters>]
Connect-XenforoApi -ApiKey "your-api-key" -ApiUrl "https://your-xenforo-site.com/api"
```

## Get-XenforoAlerts

### Synopsis
Retrieves alert details from a Xenforo forum using alert ID and user ID.

### Description
The `Get-XenforoAlerts` function queries a Xenforo forum to retrieve information about specific alerts by their ID and optionally filters by user ID. It converts the API response into custom PowerShell objects with selected properties for better readability and usability.

### Syntax
```powershell
Get-XenforoAlerts [-Id] <string> [-UserId] <string> [<CommonParameters>]
Get-XenforoAlerts -Id 12345 -UserId 1
Get-XenforoAlerts -UserId 1
```

## Get-XenforoForum

### Synopsis
Retrieves details of a specific forum node from a Xenforo forum using its ID.

### Description
The `Get-XenforoForum` function queries a Xenforo forum to retrieve information about a specific forum node by its ID. It converts the API response into a custom PowerShell object with selected properties for better readability and usability.

### Syntax
```powershell
Get-XenforoForum [-Id] <string> [<CommonParameters>]
Get-XenforoForum -Id 123
```

## Get-XenforoNodes

### Synopsis
Retrieve Xenforo nodes information based on the provided Id or all nodes.

### Description
The `Get-XenforoNodes` function retrieves node information from Xenforo based on the specified Id or returns all nodes if no Id is provided. The default output attributes include `Title`, `NodeId`, and `NodeTypeId`. For additional attributes, use `Select-Object *` to view all properties.

### Syntax
```powershell
Get-XenforoNodes [-Id] <string> [<CommonParameters>]
Get-XenforoNodes -Id 123
Get-XenforoNodes
```

## Get-XenforoPost

### Synopsis
Retrieves specific post(s) from a Xenforo forum.

### Description
The `Get-XenforoPost` function queries a Xenforo forum to retrieve information about a specific post by its ID or all posts from a specific thread by its Thread ID. It converts the API response into custom PowerShell objects with specific properties to enhance readability and usability.

### Syntax
```powershell
Get-XenforoPost [-Id] <int> [-ThreadId] <int> [<CommonParameters>]
Get-XenforoPost -Id 12345
Get-XenforoPost -ThreadId 67890
```

## Get-XenforoThreads

### Synopsis
Retrieves threads from a specified XenForo forum or the latest threads.

### Description
The `Get-XenforoThreads` function retrieves threads from a specified XenForo forum or the latest threads if no forum ID is provided. It can handle pagination and returns custom objects with default and extended properties.

### Syntax
```powershell
Get-XenforoThreads [-ForumId] <int> [-Page] <int> [-UserId] <int> [<CommonParameters>]
Get-XenforoThreads -ForumId 1
Get-XenforoThreads -ForumId 1 -Page 2
Get-XenforoThreads
```

## Get-XenforoUsers

### Synopsis
Retrieves user details from a XenForo forum using various parameters.

### Description
The `Get-XenforoUsers` function queries a XenForo forum to retrieve information about users by their ID, name, or email. It also supports retrieving all users with optional pagination. The function converts the API response into custom PowerShell objects with selected properties for better readability and usability.

### Syntax
```powershell
Get-XenforoUsers [-Id] <int> [-Name] <string> [-Email] <string> [-Page] <int> [<CommonParameters>]
Get-XenforoUsers -Id 12345
Get-XenforoUsers -Name "JohnDoe"
Get-XenforoUsers -Email "john.doe@example.com"
Get-XenforoUsers -Page 2
```

## Set-XenforoThreadRead

### Synopsis
Marks a specific XenForo thread as read for a given user.

### Description
The `Set-XenforoThreadRead` function sends a request to the XenForo API to mark a specific thread as read. You can specify the thread ID and optionally a user ID. If no user ID is provided, the API will use the context of the current API calling user.

### Syntax
```powershell
Set-XenforoThreadRead -ThreadId <string> [-UserId <string>] [<CommonParameters>]
Set-XenforoThreadRead -ThreadId "12345"
Set-XenforoThreadRead -ThreadId "12345" -UserId "67890"
```








