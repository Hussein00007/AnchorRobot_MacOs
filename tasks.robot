*** Settings ***
*** Settings ***
Library     RPA.Browser.Selenium    auto_close=${FALSE}
Library     RPA.Robocorp.Vault
Library     RPA.Excel.Files
Library     RPA.Tables
Library     RPA.Desktop
Library     String
Library     Collections
Library     RPA.Robocloud.Items
Library     RPA.RobotLogListener
Library     RPA.FileSystem
Library     Dialogs
Library     RPA.Dialogs




*** Variables ***
${Files_To_Upload}
...                                     /Users/se7s/Downloads/
${Uploaded_Files}
...                                     C:\\Users\\HusseinMaher\\OneDrive - Evolvant Technologies\\Documents\\Episodes\\Uploaded
@{First15DaysRows}                      1    2    3
@{Second16DaysRows}                     3    4    5    6
@{DaysColumns}                          1    2    3    4    5    6    7
${Days15}                               15

##### Selectors #####
${New-Episode_Button}                   xpath://*[@id="app"]/div/header/div[2]/span/div[1]/div/div/div/button

${Quick-Upload_Button}
...                                     xpath://*[@id="app"]/div/header/div[2]/span/div[1]/div/div/div[2]/div/ul/li[2]/button
${Upload_PopUp_Field}                   coordinates:1550,710
${Upload-Thumbnail_Button}              xpath://*[@id="app-content"]/div/form/div[7]/div[2]/div/button
${Confirm-Thumbnail_Button}             xpath:/html/body/reach-portal/div[2]/div/div/div/div[2]/div/div[2]/button[2]
${Switch-To-HTML_Button}                xpath://*[@id="app-content"]/div/form/div[4]/div[2]/div[1]/button
${Description_Field}                    xpath://*[@id="app-content"]/div/form/div[4]/div[2]/textarea
${Change-Date_Button}
...                                     xpath:/html/body/reach-portal/div[2]/div/div/div/div[2]/div[1]/div/div/div/table/thead/tr[1]/th[3]
${Current-Date_Text}
...                                     xpath:/html/body/reach-portal/div[2]/div/div/div/div[2]/div[1]/div/div/div/table/thead/tr[1]/th[2]
${Switch-Date_Button}
...                                     xpath:/html/body/reach-portal/div[2]/div/div/div/div[2]/div[1]/div/div/div/table/thead/tr[1]/th[3]
${Current-Hour_Text}
...                                     xpath:/html/body/reach-portal/div[2]/div/div/div/div[2]/div[1]/div/div/div/table/tbody/tr/td/div/div[1]/div
${Current-Minute_Text}
...                                     xpath:/html/body/reach-portal/div[2]/div/div/div/div[2]/div[1]/div/div/div/table/tbody/tr/td/div/div[3]/div
${Current-AMPM_Text}
...                                     xpath:/html/body/reach-portal/div[2]/div/div/div/div[2]/div[1]/div/div/div/table/tbody/tr/td/div/div[4]/div
${Change-Hour_Button}
...                                     xpath:/html/body/reach-portal/div[2]/div/div/div/div[2]/div[1]/div/div/div/table/tbody/tr/td/div/div[1]/span[1]
${Change-Minute_Button}
...                                     xpath:/html/body/reach-portal/div[2]/div/div/div/div[2]/div[1]/div/div/div/table/tbody/tr/td/div/div[3]/span[1]
${Change-AMPM_Button}
...                                     xpath:/html/body/reach-portal/div[2]/div/div/div/div[2]/div[1]/div/div/div/table/tbody/tr/td/div/div[4]/span[1]
${Confirm-Date_Button}
...                                     xpath:/html/body/reach-portal/div[2]/div/div/div/div[2]/div[2]/button[2]/span[1]
${Close-Publish-PopUp_Button}           xpath:/html/body/reach-portal/div[2]/div/div/div/div[1]/button
${Date-Now_Button}                      xpath://*[@id="app-content"]/div/form/div[5]/div/button
${Episode-Upload-File_Coordinates}      coordinates:604,148
${Thumnnail-Upload_Coordinates}         coordinates:359,444
${Upload-Filename-Write_OCR}            ocr:File name
${Paste_ShortCut}                       Windows+v
${OpenGoTab_Shortcut}                   COMMAND+SHIFT+G 
${Publish_Button}                       xpath://*[@id="app-content"]/div/form/div[1]/div[2]/button[2]
${USERNAME}                             batmansehs@yahoo.com
${PASSWORD}                             Hkh*psdk1
${Cancel_Button}                        xpath://*[@id="app-content"]/div/form/div[2]/div/div/div[1]/div[2]/button
${Audio_Preview_Available}              xpath://*[@id="app-content"]/div/form/div[2]/div[2]/div/div/div[1]/div[1]/div/span
#####################


*** Tasks ***



Entire Process
    ${Excel_File_Path}=    Collect Excel file from the user
    Open Browser And Login    ${USERNAME}    ${PASSWORD}
    ${Episodes}=    Read Excel Sheet    ${Excel_File_Path}
    FOR    ${Episode}    IN    @{Episodes}
        ${Title}=    Set Variable
        ...    ${Episode}[TITLE_PREFIX]${Episode}[EPISODE_NUMBER]${Episode}[SEPERATOR] ${Episode}[CATEGORY] - ${Episode}[TITLE] - ${Episode}[GUEST]
        ${Description}=    Set Variable
        ...    ${Episode}[DESCRIPTION_HEADER] <br><br>⚡️ <B>${Episode}[TITLE]</B><br>${Episode}[DESCRIPTION_BODY]<br><br><B>${Episode}[GUEST]</B><br>${Episode}[GUEST_BIO]<br><br>${Episode}[DESCRIPTION_FOOTER]
        @{Date}=    Split String    ${Episode}[PUBLISH_DATE]    ${SPACE}
        ${Day}=    Get From List    ${Date}    0
        ${Month}=    Get From List    ${Date}    1
        ${Year}=    Get From List    ${Date}    2
        @{Time}=    Split String    ${Episode}[PUBLISH_TIME]    ${SPACE}
        ${Hour}=    Get From List    ${Time}    0
        ${Minute}=    Get From List    ${Time}    1
        Upload One File And Thumbnail    ${Episode}[FILENAME]    ${Episode}[THUMBNAIL]
        Enter Episode Details    ${Title}    ${Description}    ${Episode}[EPISODE_NUMBER]
        Enter date    ${Day}    ${Month}    ${Year}    ${Hour}    ${Minute}    ${Episode}[AM_PM]
    END
    # Upload One File And Thumbnail    Episode25.mp4    PNG.png
    # Enter Episode Details    Episode_Title    Description    14
    # Enter date    6    05    2023    02    30    PM


*** Keywords ***
Collect Excel file from the user
    Add heading    Upload Excel File
    Add image    CoverImage.jpeg    width=1300   
    Add file input
    ...    label=Upload the Excel file with Episodes Data
    ...    name=fileupload
    ...    file_type=Excel files (*.xlsx)
    ...    destination=${OUTPUT_DIR}
    ${response}=    Run dialog    timeout=5000    height=1080    width=1920
    RETURN    ${response.fileupload}[0]   

Open Browser And Login
    [Arguments]    ${user}    ${pass}
    Set Selenium Speed    5
    Set Selenium Implicit Wait    15
    Set Selenium Timeout    15
    Open Available Browser    https://anchor.fm/login    maximized=${TRUE}
    # ${secret}=    Get Secret    Anchor_Creds
    Input Text When Element Is Visible    id:email    ${user}
    Input Text When Element Is Visible    id:password    ${pass}
    Submit Form

Read Excel Sheet
    [Arguments]    ${Excel_Path}
    Open Workbook    ${Excel_Path}
    ${worksheet}=    Read worksheet    header=${TRUE}
    ${Episodes}=    Create table    ${worksheet}
    RETURN    ${Episodes}
    [Teardown]    Close workbook

Upload One File And Thumbnail
    [Arguments]    ${Episode_Name}    ${Thumbnail}
    Sleep     2 seconds
    Click Element When Visible    ${New-Episode_Button}
    Sleep     2 seconds
    Click Element When Visible    ${Quick-Upload_Button}
    Sleep     1 second
    Set Clipboard Value    ${Files_To_Upload}${Episode_Name}
    RPA.Desktop.Press Keys    shift    cmd    esc        # path tab
    Sleep     5 seconds   
    RPA.Desktop.Press Keys    shift    cmd    F1         # Paste
    Sleep     3 second
    RPA.Desktop.Press Keys    shift    cmd    F2         # Enter
    Sleep     3 seconds
    RPA.Desktop.Press Keys    shift    cmd    F2         # Enter
    Sleep     5 seconds  
    ${stripped}=    Strip String    ${Files_To_Upload}${Thumbnail}

    IF    '${Thumbnail}' == 'yyyyyyy'
        Wait Until Element Is Enabled    ${Upload-Thumbnail_Button}
        Click Element When Visible    ${Upload-Thumbnail_Button}
        Sleep     1 second
        RPA.Desktop.Press Keys    shift    cmd    esc        # path tab
        Sleep     3 seconds
        Set Clipboard Value    ${Files_To_Upload}${Thumbnail}   
        RPA.Desktop.Press Keys    shift    cmd    F1         # Paste
        Sleep     2 seconds
        RPA.Desktop.Press Keys    shift    cmd    F2         # Enter
        Sleep     5 seconds
        RPA.Desktop.Press Keys    shift    cmd    F2         # Enter
        Click Element When Visible    ${Confirm-Thumbnail_Button}
    END  
    

Enter Episode Details
    [Arguments]    ${Title}    ${Description}    ${Episode_Number}
    Wait Until Keyword Succeeds    500x    3 seconds    Input Text    id:title    ${Title}
    Input Text    id:podcastEpisodeNumber    ${Episode_Number}
    Click Element When Visible    ${Switch-To-HTML_Button}
    Click Element When Visible    ${Description_Field}
    Set Clipboard Value    ${Description}
    RPA.Browser.Selenium.Press Keys    None    COMMAND+V
    

Enter date
    [Arguments]    ${Day}    ${Month}    ${Year}    ${Hour}    ${Min}    ${AMPM}

    IF    '${Month}' == '01'
        ${MMM}=    Set Variable    January
    END
    IF    '${Month}' == '02'
        ${MMM}=    Set Variable    February
    END
    IF    '${Month}' == '03'
        ${MMM}=    Set Variable    March
    END
    IF    '${Month}' == '04'
        ${MMM}=    Set Variable    April
    END
    IF    '${Month}' == '05'
        ${MMM}=    Set Variable    May
    END
    IF    '${Month}' == '06'
        ${MMM}=    Set Variable    June
    END
    IF    '${Month}' == '07'
        ${MMM}=    Set Variable    July
    END
    IF    '${Month}' == '08'
        ${MMM}=    Set Variable    August
    END
    IF    '${Month}' == '09'
        ${MMM}=    Set Variable    September
    END
    IF    '${Month}' == '10'
        ${MMM}=    Set Variable    October
    END
    IF    '${Month}' == '11'
        ${MMM}=    Set Variable    November
    END
    IF    '${Month}' == '12'
        ${MMM}=    Set Variable    December
    END

    Click Element When Visible    ${Date-Now_Button}
    ${CurrentDate}=    Get Text    ${Current-Date_Text}
    ${CurrentDate}=    Strip String    ${CurrentDate}    mode=both

    WHILE    '${CurrentDate}' != '${MMM} ${Year}'
        Click Element When Visible    ${Change-Date_Button}
        ${CurrentDate}=    Get Text    ${Current-Date_Text}
        ${CurrentDate}=    Strip String    ${CurrentDate}    mode=both
    END

    # Getting Day Element

    ${DayInt}=    Convert To Integer    ${Day}
    ${Days15}=    Convert To Integer    ${Days15}
    IF    ${Days15} > ${DayInt}
        FOR    ${Row}    IN    @{First15DaysRows}
            FOR    ${Column}    IN    @{DaysColumns}
                ${Locator}=    Set Variable
                ...    xpath:/html/body/reach-portal/div[2]/div/div/div/div[2]/div[1]/div/div/div/table/tbody/tr[${Row}]/td[${Column}]
                ${ExtractedDay}=    Wait Until Keyword Succeeds    3x    10 seconds    Get Text    ${Locator}

                IF    '${ExtractedDay}' == '${Day}'                    BREAK
            END
            IF    '${ExtractedDay}' == '${Day}'                BREAK
        END
    END
    IF    ${DayInt} >= ${Days15}
        FOR    ${Row}    IN    @{Second16DaysRows}
            FOR    ${Column}    IN    @{DaysColumns}
                ${Locator}=    Set Variable
                ...    xpath:/html/body/reach-portal/div[2]/div/div/div/div[2]/div[1]/div/div/div/table/tbody/tr[${Row}]/td[${Column}]
                ${ExtractedDay}=    Wait Until Keyword Succeeds    3x    10 seconds    Get Text    ${Locator}

                IF    '${ExtractedDay}' == '${Day}'                    BREAK
            END
            IF    '${ExtractedDay}' == '${Day}'                BREAK
        END
    END

    # Click On Day Element
    Click Element When Visible    ${Locator}
    Click Element When Visible    class:rdtTimeToggle

    # Getting Time Information
    ${CurrentHour}=    Get Text    ${Current-Hour_Text}
    ${CurrentMin}=    Get Text    ${Current-Minute_Text}
    ${CurrentAMPM}=    Get Text    ${Current-AMPM_Text}
    ${CurrentHour}=    Convert To Integer    ${CurrentHour}
    ${CurrentMin}=    Convert To Integer    ${CurrentMin}
    ${Hour}=    Convert To Integer    ${Hour}
    ${Min}=    Convert To Integer    ${Min}

    # Select Hour

    WHILE    ${CurrentHour} != ${Hour}
        Click Element When Visible    ${Change-Hour_Button}
        ${CurrentHour}=    Get Text    ${Current-Hour_Text}
        ${CurrentHour}=    Convert To Integer    ${CurrentHour}
    END

    # Select Minute

    WHILE    ${CurrentMin} != ${Min}
        Click Element When Visible    ${Change-Minute_Button}
        ${CurrentMin}=    Get Text    ${Current-Minute_Text}
        ${CurrentMin}=    Convert To Integer    ${CurrentMin}
    END

    WHILE    '${CurrentAMPM}' != '${AMPM}'
        Click Element When Visible    ${Change-AMPM_Button}
        ${CurrentAMPM}=    Get Text    ${Current-AMPM_Text}
    END

    Click Element When Visible    ${Confirm-Date_Button}
    

    ${Audio_Available_Text}=    Wait Until Keyword Succeeds    300x    5 seconds    Get Text    ${Audio_Preview_Available}

    WHILE    '${Audio_Available_Text}' != 'Audio preview available. Your video will be processed when you publish.'
        sleep     2 seconds
        ${Audio_Available_Text}=    Wait Until Keyword Succeeds    300x    5 seconds    Get Text    ${Audio_Preview_Available}
    END
    
    Wait Until Keyword Succeeds    300x    5 seconds    Click Button When Visible    ${Publish_Button}  

    Click Element When Visible    ${Close-Publish-PopUp_Button}




Test Keyword

    [Arguments]    ${user}    ${pass}
    Set Selenium Speed    5
    Set Selenium Implicit Wait    15
    Set Selenium Timeout    15
    Open Available Browser    https://anchor.fm/login    maximized=${TRUE}
    # ${secret}=    Get Secret    Anchor_Creds
    Input Text When Element Is Visible    id:email    ${user}
    Input Text When Element Is Visible    id:password    ${pass}
    Click Element When Visible    alias:Span
    Click Element When Visible    ${New-Episode_Button}
    Click Element When Visible    ${Quick-Upload_Button}
    Sleep    3 seconds
    RPA.Desktop.Press Keys    shift    cmd    esc  
    Sleep    1 second
    Click    ${Episode-Upload-File_Coordinates}
    Set Clipboard Value    /Users/Se7s/Downloads/  
    Paste From Clipboard    ${Episode-Upload-File_Coordinates}      
    RPA.Desktop.Press Keys    shift    cmd    F1         # Paste
    RPA.Desktop.Press Keys    shift    cmd    F2         # Enter
    Sleep     5 seconds
    RPA.Desktop.Press Keys    shift    cmd    F2         # Enter



Test Keyboard   
    Open Available Browser    www.google.com
    Sleep    3 seconds
    RPA.Browser.Selenium.Press Keys    /html/body/div[1]/div[3]/form/div[1]/div[1]/div[1]/div/div[2]/input    COMMAND+SHIFT+G 
    Sleep    1 second


