Import $;

File:=$.raw_Education.File;

Layout:=Record
  String18 state_ut:=File.STATNAME;
  UNSIGNED4 overall_lit:=(UNSIGNED4)File.OVERALL_LI;//Literacy rate
  UNSIGNED4 Male_lit:=(UNSIGNED4)File.MALE_LIT;//Male literacy
  UNSIGNED4 Female_lit:=(UNSIGNED4)File.FEMALE_LIT;//Female Literacy
  UNSIGNED4 Tot:=(UNSIGNED4)File.SCHTOT;//Total Schools
  UNSIGNED4 Tot_Gov:=(UNSIGNED4)File.SCHTOTG;//No of Government School
  UNSIGNED4 Tot_Prv:=(UNSIGNED4)File.SCHTOTP;//No of Public School
  UNSIGNED4 Climate:=(UNSIGNED4)File.ROADTOT;//Transportation to school facility
  UNSIGNED4 Playground:=(UNSIGNED4)File.SPLAYTOT;
  UNSIGNED4 BoundaryWall:=(UNSIGNED4)File.SBNDRTOT;
  UNSIGNED4 water:=(UNSIGNED4)File.SWATTOT;
  UNSIGNED4 electricity:=(UNSIGNED4)File.SELETOT;
  UNSIGNED4 comp:=(UNSIGNED4)File.SCOMPTOT;//Computer facility
  end;

  SET OF STRING18 UT:=['','DADRA & NAGAR HAVE','DAMAN & DIU','LAKSHADWEEP','TOTCLOT3G']; //Removal of Union Territory in dataset

  File_Education:=Table(File(statname NOT IN UT),Layout);
  
OUTPUT(File_Education,,'~singlehunter::hack::filt_education',NAMED('filtered'),OVERWRITE);
