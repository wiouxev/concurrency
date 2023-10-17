    ###################################################################################################
    ### Alternative ODJ script to include specific GPO policy, including issuing cert for IRI PRISMA ##
    ###################################################################################################
    
     Import-csv -path "C:\concurrency\scripts\Offline Domain Join\odjcomputers.csv" | ForEach {
     $filename = $_.Computername
     DJOIN.EXE /Provision /Reuse /Domain infores.com /Machine $_.Computername /Savefile "C:\Program Files\Binary Tree\Dirsync\Downloads\ODJ\$filename.txt" /policynames "VPN_autoenrol_authentication_iriintcawp02;Global_OneDrive_NPD;Default Domain Policy" /rootcacerts /certtemplate VPN_Comp_auto_enrol_auth
     }


    ## to add later : new GPO for onedrive fix (need name)... can affix with ';'
    ## Global_OneDrive_NPD
    ## also to add pre-logon reg keys via BT