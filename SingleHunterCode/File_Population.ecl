Import $,STD;
ds:=$.raw_population.ds;
layout:=$.raw_population.sampleLayout;
EXPORT File_population := Module

EXPORT Layout:=RECORD
    STRING state;
    UNSIGNED5 at2000;
    UNSIGNED5 at2011;
END;

Layout trans(ds l):=Transform
stateUpper:=std.Str.ToUpperCase(l.___States_Union_Territories);
  self.state:=map(stateUpper='ANDAMAN AND NICOBA'=>'A & N ISLANDS',
    stateUpper='JAMMU AND KASHMIR'=>'JAMMU & KASHMIR',
    stateUpper);//Converting into Upper case & Changing name
  Self.at2000:=l._000_01_INC;
  Self.at2011:=l._011_12_INC;
END;
EXPORT File:=Project(ds,trans(LEFT)):Persist('~SingleHunter::hack::persist::statewise_population');
end;