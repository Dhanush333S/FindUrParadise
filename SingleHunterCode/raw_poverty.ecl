EXPORT raw_poverty := Module
  
  Export layout:=RECORD
    STRING State;
    STRING Rural_2011_12_Poverty_Expenditure_Per_Capita;
    STRING Urban_2011_12_Poverty_Expenditure_Per_Capita;
    STRING Headcount_Ratio____;
    STRING _011_rural_percentage;
    STRING FII_Rank;
    STRING CFII;
    STRING CDI;
  END;

Export File:=DATASET('~singlehunter::hack::poverty::singlehunter_poverty.csv',layout,CSV(HEADING(1)));

end;