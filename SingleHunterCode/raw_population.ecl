Import std;
EXPORT raw_population := MODULE

EXport sampleLayout:=RECORD
    STRING18 ___States_Union_Territories;
    UNSIGNED5 _000_01_INC;
    UNSIGNED5 _011_12_INC;
    UNSIGNED5 _001___LIT;
    UNSIGNED5 _011__LIT;
    UNSIGNED5 _001___POP;
    UNSIGNED5 _011__POP;
    UNSIGNED5 _001__SEX_Ratio;
    UNSIGNED5 _011__SEX_Ratio;
    UNSIGNED5 _001__UNEMP;
    UNSIGNED5 _011__UNEMP;
    UNSIGNED5 _001__Poverty;
    UNSIGNED5 _011__Poverty;
END;

EXport ds:=DATASET('~singlehunter::hack::state::state_population::singlehunter_statewise_population.csv',sampleLayout,CSV(HEADING(1)));



END;