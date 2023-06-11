
CrimeRec:=Record
String18 state_ut;
REAL Murder;
REAL Rape;
REAL Kidnap;
REAL Kill_Ratio;
REAL Dacoity;
REAL burglary;
REAL cheat;
REAL cruelty;
REAL Hurt_Ratio;
End;

Crime := DATASET('~SingleHunter::hack::output::CrimeAnalyze',CrimeRec,FLAT);

rankRec:=RECORD
Crime.state_ut;
Crime.Kill_Ratio;
Crime.Hurt_Ratio;
DECIMAL5_2 Kill_Score:=0;
DECIMAL5_2 HURT_Score:=0;
end;

rankTable:=Table(Crime,rankRec);

AddKillScore := ITERATE(SORT(rankTable,Kill_Ratio),TRANSFORM(rankRec,
                                                                   SELF.Kill_Score := IF(LEFT.Kill_Ratio=RIGHT.Kill_Ratio,LEFT.Kill_Score,LEFT.Kill_Score+1),
                                                                   SELF := RIGHT));
AddHurtScore := ITERATE(SORT(AddKillScore,Hurt_Ratio),TRANSFORM(rankRec,SELF.Hurt_Score := IF(LEFT.Hurt_Ratio=RIGHT.Hurt_Ratio,LEFT.Hurt_Score,LEFT.Hurt_Score+1),SELF := RIGHT));
OUTPUT(AddHurtScore,,'~SingleHunter::hack::output::CrimeScores',NAMED('CrimeScore'),OVERWRITE);