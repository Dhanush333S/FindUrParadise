Import $;

AnalyzeRec :=Record
String18 state_ut;
Real genderEdu;
Real schoolEdu;
Real facility;
End;

analyze := DATASET('~singlehunter::hack::output::File_EducationAnalyze',AnalyzeRec,FLAT);

rankRec :=Record
analyze.state_ut;
analyze.genderEdu;
analyze.schoolEdu;
analyze.facility;
UNSIGNED GenderScore:=0;
UNSIGNED schoolScore:=0;
UNSIGNED facilityScore:=0;
End;

rankTable:=Table(analyze(state_ut NOT IN ['TELANGANA','DADRA & NAGAR HAVE']),rankRec);
AddGenderScore := ITERATE(SORT(rankTable,-genderEdu),TRANSFORM(rankRec,
                                                                   SELF.GenderScore := IF(LEFT.genderEdu=RIGHT.genderEdu,LEFT.GenderScore,LEFT.GenderScore+1),
                                                                   SELF := RIGHT));
AddSchoolScore := ITERATE(SORT(AddGenderScore,-schoolEdu),TRANSFORM(rankRec,SELF.schoolScore := IF(LEFT.schoolEdu=RIGHT.schoolEdu,LEFT.schoolScore,LEFT.schoolScore+1),SELF := RIGHT));

AddFacilityScore := ITERATE(SORT(AddSchoolScore,-facility),TRANSFORM(rankRec,SELF.facilityScore := IF(LEFT.facility=RIGHT.facility,LEFT.facilityScore,LEFT.facilityScore+1),SELF := RIGHT));

OUTPUT(AddFacilityScore,,'~SingleHunter::hack::output::EducationScore',NAMED('EducationScore'),OVERWRITE);
