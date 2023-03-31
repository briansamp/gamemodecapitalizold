// Admin Defines
#define MAX_REPORTS  1000
#define INVALID_REPORT_ID -1

enum reportinfo
{
	HasBeenUsed,
	Report[128],
	ReportFrom,
	CheckingReport,
 	TimeToExpire,
	BeingUsed,
	ReportExpireTimer,
	ReplyTimerr
}

new Reports[MAX_REPORTS][reportinfo];
new ListItemReportId[MAX_PLAYERS][40];
new CancelReport[MAX_PLAYERS];

stock SendReportToQue(reportfrom, report[])
{
    new bool:breakingloop = false, newid = INVALID_REPORT_ID;

	for(new i=0;i<MAX_REPORTS;i++)
	{
		if(!breakingloop)
		{
			if(Reports[i][HasBeenUsed] == 0)
			{
				breakingloop = true;
				newid = i;
			}
		}
    }
    if(newid != INVALID_REPORT_ID)
    {
        strmid(Reports[newid][Report], report, 0, strlen(report), 128);
        Reports[newid][ReportFrom] = reportfrom;
        Reports[newid][TimeToExpire] = 5;
        Reports[newid][HasBeenUsed] = 1;
        Reports[newid][BeingUsed] = 1;
        Reports[newid][ReportExpireTimer] = SetTimerEx("ReportTimer", 60000, 0, "d", newid);
        new String[212];
        format(String, sizeof(String), "{F7FF00}[REPORT:%d] {00CCFF}%s[id:%d]\n.", newid, pData[reportfrom][pName], reportfrom);
        SendStaffMessage(COLOR_WHITE,String,1);
        format(String, sizeof(String), "{00FF00}[Reason Report]: %s", (report));
        SendStaffMessage(COLOR_WHITE,String,1);
    }
    else
    {
        ClearReports();
        SendReportToQue(reportfrom, report);
    }
}

function ClearReports()
{
	for(new i=0;i<MAX_REPORTS;i++)
	{
		strmid(Reports[i][Report], "None", 0, 4, 4);
		Reports[i][CheckingReport] = 999;
        Reports[i][ReportFrom] = 999;
        Reports[i][TimeToExpire] = 5;
        Reports[i][HasBeenUsed] = 0;
        Reports[i][BeingUsed] = 0;
	}
	return 1;
}

forward ReportTimer(reportid);
public ReportTimer(reportid)
{
	if(Reports[reportid][BeingUsed] == 1)
	{
	    if(Reports[reportid][TimeToExpire] > 0)
	    {
	        Reports[reportid][TimeToExpire]--;
	        if(Reports[reportid][TimeToExpire] == 0)
	        {
	            SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_GRAD2, "Your report has expired. You can attempt to report again if you wish.");
	            Reports[reportid][BeingUsed] = 0;
	            Reports[reportid][ReportFrom] = 999;
	            return 1;
	        }
  			Reports[reportid][ReportExpireTimer] = SetTimerEx("ReportTimer", 60000, 0, "d", reportid);
		}
	}
	return 1;
}

CMD:report(playerid, params[])
{
	if(pData[playerid][pReportTime] > 0)
	{
		Error(playerid,"Wait 120 seconds before sending another report!");
		return 1;
	}

	if(isnull(params)) return Usage(playerid, "/report [text]");

	pData[playerid][pReportTime] = 180;
	SendReportToQue(playerid, params);
	SendClientMessageEx(playerid, COLOR_ARWIN, "REPORT: {ffffff}Your report has been issued to the queue, use '{ffff00}/reports{ffffff}' to see your report");
	return 1;
}

CMD:reports(playerid, params[])
{
	new reportdialog[1000], itemid = 0;
	format(reportdialog, sizeof(reportdialog), "#Reports\tIssuer\tMessage\n");
	for(new i; i < MAX_REPORTS; ++i)
	{
		if(Reports[i][BeingUsed] == 1 && itemid < 40)
		{
			ListItemReportId[playerid][itemid] = i;
			itemid++;
			format(reportdialog, sizeof(reportdialog), "%s%i\t%s\t%s", reportdialog, i, pData[Reports[i][ReportFrom]][pName], (Reports[i][Report]));
			format(reportdialog, sizeof(reportdialog), "%s\n", reportdialog);
		}
	}
	CancelReport[playerid] = itemid;
	format(reportdialog, sizeof(reportdialog), "%s", reportdialog);
	ShowPlayerDialog(playerid, DIALOG_REPORTS, DIALOG_STYLE_TABLIST_HEADERS, "Reports", reportdialog, "Close", "");
	return 1;
}

CMD:ar(playerid, params[])
{
	if(pData[playerid][pAdmin] >= 1)
	{
		new String[212], reportid;
		if(sscanf(params, "d", reportid)) return Usage(playerid, "/ar [reportid]");
		if(reportid < 0 || reportid > 999) { Error(playerid, "Report ID not below 0 or above 999!"); return 1; }
		if(Reports[reportid][BeingUsed] == 0) return Error(playerid, "That report ID is not being used!");
		if(!IsPlayerConnected(Reports[reportid][ReportFrom]))
		{
			Error(playerid, "The reporter has disconnected !");
			Reports[reportid][ReportFrom] = 999;
			Reports[reportid][BeingUsed] = 0;
			return 1;
		}
		format(String, sizeof(String), "RESPOND: {FF0000}%s {FFFFFF}has accepted the report from {00FFFF}%s[id:%d].", pData[playerid][pAdminname], pData[Reports[reportid][ReportFrom]][pName],Reports[reportid][ReportFrom]);
		SendStaffMessage(COLOR_ARWIN, String, 1);
		format(String, sizeof(String), "RESPOND: {FF0000}%s {FFFFFF}has responded to your report", pData[playerid][pAdminname]);
		SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_ARWIN, String);
	    Reports[reportid][BeingUsed] = 0;
		Reports[reportid][ReportFrom] = 999;
	    Reports[reportid][CheckingReport] = 999;
		Reports[reportid][CheckingReport] = playerid;
		Reports[reportid][BeingUsed] = 0;
		Reports[reportid][TimeToExpire] = 0;
		strmid(Reports[reportid][Report], "None", 0, 4, 4);
	}
	return 1;
}

CMD:dr(playerid, params[])
{
	if(pData[playerid][pAdmin] >= 1)
	{
		new string[212], reportid;
		if(sscanf(params, "d", reportid)) return Usage(playerid, "/dr [reportid]");

		if(reportid < 0 || reportid > 999) { Error(playerid, "Report ID not below 0 or above 999!"); return 1; }
		if(Reports[reportid][BeingUsed] == 0) return Error(playerid, "That report ID is not being used!");
		if(!IsPlayerConnected(Reports[reportid][ReportFrom]))
		{
			Error(playerid, "The reporter has disconnected !");
			Reports[reportid][ReportFrom] = 999;
			Reports[reportid][BeingUsed] = 0;
			return 1;
		}
		format(string, sizeof(string), "RESPOND: {FF0000}%s {FFFFFF}has trashed the report from {00FFFF}%s[id:%d].", pData[playerid][pAdminname], pData[Reports[reportid][ReportFrom]][pName],Reports[reportid][ReportFrom]);
		SendStaffMessage(COLOR_ARWIN, string, 1);
		Reports[reportid][ReportFrom] = 999;
		Reports[reportid][BeingUsed] = 0;
		Reports[reportid][TimeToExpire] = 0;
		strmid(Reports[reportid][Report], "None", 0, 4, 4);
	}
	return 1;
}

CMD:clearallreports(playerid, params[])
{
    if (pData[playerid][pAdmin] >= 5) {
        new String[212];
        ClearReports();
        SendClientMessageEx(playerid,COLOR_GRAD2, "You have cleared all the active reports.");
        format(String, sizeof(String), "{FF6347}AdmCmd: %s has cleared all the pending reports.", pData[playerid][pAdminname]);
        SendStaffMessage(TOMATO, String, 2);
    }
    else {
        Error(playerid, "You don't have the privilege to use this command!");
    }
    return 1;
}
