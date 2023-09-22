# **NBA-Statistics-APP**
*(Polished official NBA Statistics APP)*

## **PROPOSAL:**

### **Explain in few words what your app does:**
- My app is an NBA Statistic app that implements 4 key features:
    - a home/favorites screen,
    - a Team screen,
    - a Players screen, and
    - a Games screen.
- Upon selecting a given team or player, a user can view some of its historical or season-specific data.
- Through the powerful API used, the data is constantly being updated.
- The Game screen will continually show users what the upcoming matches will be, perhaps with the ability to set reminders for a certain game.

### **Who is the target audience of your app?**
- My audience are people who are basketball fans, and enjoy knowing about and staying up to date on the game.
- It is somewhat similar in idea to NBA cards, but now given a digital touch with continuously updating data.

### **Are there apps similar to yours in the App Store? If yes, please list a few:**
- There are a few specifically – NBA: Live Games & Scores

### **What REST API(s) will your app call? Provide the base URL and endpoint(s):**
- The teams, players, and games data will be provided via the following REST API:
    - Documentation URL for API: [https://sportsdata.io/](https://sportsdata.io/)
    - Base URI: [https://sportsdata.io/developers/api-documentation/nba](https://sportsdata.io/developers/api-documentation/nba)
    - Endpoint: /Players
        - Description: Players provide details by active players, their teams, profile, position, background info, etc.
    - Endpoint: /Teams
        - Description: Teams provide the name, city, conference, division, and logo.
    - Endpoint: /Games
        - Description: Games provide the upcoming scheduled game, date time, the home and away team. It can also provide the score if the game has been played already.

### **Wireframe:**
- Link: [https://www.figma.com/file/iA9AXXNRRzSqdKzj1LU1jY/NBA-Stats-APP?node-id=0%3A1](https://www.figma.com/file/iA9AXXNRRzSqdKzj1LU1jY/NBA-Stats-APP?node-id=0%3A1)

![Wireframe](https://i.imgur.com/O24wJIT.png)

