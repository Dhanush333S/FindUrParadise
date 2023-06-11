Import $;
Crime:=$.File_Crime.File;

//We calculate Weighted Average Here

CrossTabLayout:=Record
state_ut:=if(Crime.state_ut='DELHI UT','DELHI',Crime.state_ut);
Crime.year;
Murder:=ROUND(AVE(Group,3*Crime.MURDER+2*Crime.ATTEMPT_TO_MURDER+Crime.CULPABLE_HOMICIDE_NOT_AMOUNTING_TO_MURDER+Crime.CAUSING_DEATH_BY_NEGLIGENCE)/7);
Rape:=ROUND(AVE(Group,3*Crime.RAPE+2*Crime.CUSTODIAL_RAPE+1*Crime.OTHER_RAPE)/6);
Kidnap:=ROUND(AVE(Group,Crime.KIDNAPPING___ABDUCTION));//Other two Kidnapping cases adds up to this value
Dacoity:=ROUND(AVE(Group,2*Crime.DACOITY+Crime.PREPARATION_AND_ASSEMBLY_FOR_DACOITY)/3);
burglary:=ROUND(AVE(Group,3*Crime.ROBBERY+3*Crime.BURGLARY+2*Crime.THEFT+2*Crime.AUTO_THEFT+Crime.OTHER_THEFT)/11);
cheat:=ROUND(AVE(Group,Crime.RIOTS+Crime.CRIMINAL_BREACH_OF_TRUST+Crime.CHEATING+Crime.COUNTERFIETING+Crime.ARSON)/5);
cruelty:=ROUND(AVE(Group,2*Crime.HURT_GREVIOUS_HURT+3*Crime.DOWRY_DEATHS+3*Crime.ASSAULT_ON_WOMEN_WITH_INTENT_TO_OUTRAGE_HER_MODESTY+Crime.INSULT_TO_MODESTY_OF_WOMEN+Crime.CRUELTY_BY_HUSBAND_OR_HIS_RELATIVES+2*Crime.IMPORTATION_OF_GIRLS_FROM_FOREIGN_COUNTRIES)/12);
End;

SET OF STRING18 UT:=['','D & N HAVELI','DAMAN & DIU','LAKSHADWEEP']; //Removal of Union Territory in dataset
AveCrime:=Table(Crime(state_ut NOT IN UT),CrossTabLayout,State_ut,year);
//Sort(AveCrime,state_ut);
population:=$.File_population.File;

newRec:=Record
CrossTabLayout;
Unsigned5 population;
end;


/*
Population is measured at yr 2000 & 2011 in India --- 12 yrs gap including 2000
Here we estimate population in the mid years using growth function
*/

newRec trans(AveCrime l,population p):=Transform
self.population:=p.at2000*exp(((2000-l.year)/11)*ln(p.at2000/p.at2011));//This is the growth function
self:=l;
end;

joinTable:=Join(AveCrime,population,LEFT.state_ut=RIGHT.state,trans(left,right),lookup,left outer);

CrimeRec:=Record
String18 state_ut;
UNSIGNED2 year;
REAL Murder;
REAL Rape;
REAL Kidnap;
REAL Dacoity;
REAL burglary;
REAL cheat;
REAL cruelty;
End;

CrimeRec analyze(joinTable l):=Transform
Self.state_ut:=l.state_ut;
Self.year:=l.year;
Self.Murder:=((l.murder)/l.population)*10000;//Here 10000 is just to have number greater than 1
Self.Rape:=((l.Rape)/l.population)*10000;
Self.Kidnap:=((l.kidnap)/l.population)*10000;
Self.Dacoity:=((l.dacoity)/l.population)*10000;
Self.burglary:=((l.burglary)/l.population)*10000;
Self.cheat:=((l.cheat)/l.population)*10000;
Self.cruelty:=((l.cruelty)/l.population)*10000;
end;
AvgTable:=Project(joinTable,analyze(LEFT));

//Finally group by year;
FinalCrimeRec:=Record
AvgTable.state_ut;
REAL Murder:=AVE(Group,AvgTable.Murder);
REAL Rape:=AVE(Group,AvgTable.Rape);
REAL Kidnap:=AVE(Group,Avgtable.Kidnap);
REAL Kill_Ratio:=AVE(Group,AvgTable.Murder+AvgTable.Rape+Avgtable.Kidnap); //This is cases involving KILLS
REAL Dacoity:=AVE(Group,Avgtable.Dacoity);
REAL burglary:=AVE(Group,Avgtable.burglary);
REAL cheat:=AVE(Group,Avgtable.cheat);
REAL cruelty:=AVE(Group,Avgtable.cruelty); 
REAL Hurt_Ratio:=AVE(Group,Avgtable.Dacoity+Avgtable.burglary+Avgtable.cheat+Avgtable.cruelty);//This involves cases without KILLS
End;

FinalAnalyzeTable:=Table(AvgTable,FinalCrimeRec,state_ut);

OUTPUT(FinalAnalyzeTable,,'~SingleHunter::hack::output::CrimeAnalyzeCrimeAnalyze',NAMED('CrimeRatiosByPopulation'),OVERWRITE);