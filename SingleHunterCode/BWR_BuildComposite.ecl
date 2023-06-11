Import $;
CrimeDS    := $.Composite.CrimeScoreDS;
EdDS       := $.Composite.EduScoreDS;
PovertyDS  := $.Composite.PovertyScoreDS;
CombLayout := $.Composite.Layout;

MergeCrime := PROJECT(CrimeDS,TRANSFORM(CombLayout,SELF.state_ut := LEFT.state_ut,SELF := LEFT,SELF := []));
//OUTPUT(MergeCrime,NAMED('AddCrime'));

MergeEdu := JOIN(MergeCrime,EdDS,
                   LEFT.State_ut = Right.State_ut,
                   TRANSFORM(CombLayout,
                             SELF.genderEdu := RIGHT.genderEdu,
                             SELF.schoolEdu    := RIGHT.schoolEdu,
                             SELF.facility   := RIGHT.facility,
                             SELF.schoolScore := RIGHT.schoolScore,
                             SELF.GenderScore := RIGHT.GenderScore,
                             SELF.facilityScore := RIGHT.facilityScore,
                             SELF := LEFT),LOOKUP);
OUTPUT(MergeEdu,NAMED('AddEducation'));

MergePoverty := JOIN(MergeEdu,PovertyDS,
                   LEFT.State_ut = Right.State,
                   TRANSFORM(CombLayout,
                             SELF.rural := RIGHT.rural,
                             SELF.urban    := RIGHT.urban,
                             SELF.ruralScore   := RIGHT.ruralScore,
                             SELF.urbanScore := RIGHT.urbanScore,
                             SELF := LEFT),LOOKUP);
                             
OUTPUT(MergePoverty,NAMED('AddPoverty'));     

CombLayout CompTotal(CombLayout Le) := TRANSFORM
 SELF.ParadiseScore := Le.Kill_Score + Le.HURT_Score + Le.GenderScore + Le.schoolScore + Le.facilityScore +
                       Le.ruralScore + Le.urbanScore;
 SELF := Le;
END;                         

ParadiseSummary := PROJECT(MergePoverty,CompTotal(LEFT));

OUTPUT(ParadiseSummary,,'~singlehunter::hack::output::ParadiseScores',NAMED('Final_Output'),OVERWRITE);
