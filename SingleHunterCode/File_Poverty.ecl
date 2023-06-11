Import $,STD;
ds:=$.raw_poverty.File;
  Layout:=RECORD
    STRING18 state;
    UNSIGNED4 rural;
    UNSIGNED4 urban;
  END;
  Layout trans(ds l):=Transform
  stateUpper:=std.Str.ToUpperCase(l.State);
  self.state:=map(stateUpper='ORISSA/ODISHA'=>'ODISHA',
                  stateUpper='UTTARKHAND'=>'UTTARAKHAND',
                  stateUpper);//Converting into Upper case & Changing name
  r:=l.Rural_2011_12_Poverty_Expenditure_Per_Capita;
  Self.rural:=(UNSIGNED4)STD.Str.FilterOut(r, ',');
  u:=l.Urban_2011_12_Poverty_Expenditure_Per_Capita;
  Self.urban:=(UNSIGNED4)STD.Str.FilterOut(u, ',');
  END;

  File:=Project(ds(state<>'India'),trans(LEFT));


rankRec:=RECORD
    File.state;
    File.rural;
    File.urban;
    UNSIGNED4 ruralScore:=0;
    UNSIGNED4 urbanScore:=0;
END;

SET OF STRING18 UT:=['','DADRA & NAGAR HAVE','DAMAN & DIU','LAKSHADWEEP']; //Removal of Union Territory in dataset
rankTable:=Table(File(state NOT IN UT),rankRec);

AddRuralScore := ITERATE(SORT(rankTable,rural),TRANSFORM(rankRec,SELF.ruralScore := IF(LEFT.rural=RIGHT.rural,LEFT.ruralScore,LEFT.ruralScore+1),
                                                                   SELF := RIGHT));
AddUrbanScore := ITERATE(SORT(AddRuralScore,urban),TRANSFORM(rankRec,SELF.urbanScore := IF(LEFT.urban=RIGHT.urban,LEFT.urbanScore,LEFT.urbanScore+1),SELF := RIGHT));

OUTPUT(AddUrbanScore,,'~SingleHunter::hack::output::PovertyScore',NAMED('PovertyScore'),OVERWRITE);