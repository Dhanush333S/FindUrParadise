Import $;

Layout:=RECORD
  string18 state_ut;
  unsigned4 overall_lit;
  unsigned4 male_lit;
  unsigned4 female_lit;
  unsigned4 tot;
  unsigned4 tot_gov;
  unsigned4 tot_prv;
  unsigned4 climate;
  unsigned4 playground;
  unsigned4 boundarywall;
  unsigned4 water;
  unsigned4 electricity;
  unsigned4 comp;
 END;
 
Filt := DATASET('~singlehunter::hack::filt_education',Layout,FLAT);
output(Filt);
AnalyzeRec :=Record
String18 state_ut;
Real genderEdu;
Real schoolEdu;
Real facility;
End;

AnalyzeRec trans(Filt Tab):=Transform
Self.state_ut:=Tab.state_ut;
Self.genderEdu:=Tab.overall_lit/Abs(Tab.Male_lit-Tab.Female_lit);
Self.schoolEdu:=(Tab.Tot_Gov)/(Tab.Tot)*100;
Self.facility:=((3*Tab.water+3*Tab.electricity+3*Tab.Climate+2*Tab.comp+2*Tab.playground+2*Tab.BoundaryWall)/(15*Tab.Tot))*100;
end;

analyze:=Project(Filt,trans(LEFT));
OUTPUT(analyze,,'~singlehunter::hack::output::EducationAnalyze',NAMED('CountsRatios'),OVERWRITE);