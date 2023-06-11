IMPORT $;
ParaIDX := $.Composite.IDX;

EXPORT FindUrParadise() := FUNCTION
Parms := STORED($.ParadiseInput);

RECORDOF(ParaIDX) CalcScore(ParaIDX Le) := TRANSFORM
 KC  := IF(Parms.Kill_Crime,Le.kill_score,0);
 HC  := IF(Parms.Hurt_Crime,Le.hurt_score,0);
 GE  := IF(Parms.Gender_Equality,Le.genderscore,0);
 PP   := IF(Parms.Prefer_Government,Le.schoolscore,0);
 DF   := IF(Parms.Demand_Facility,Le.facilityscore,0);
 LR  := IF(Parms.Live_In_Rural,Le.ruralscore,0);
 LU   := IF(Parms.Live_In_Urban,Le.urbanscore,0);
 SELF.ParadiseScore := KC+HC+GE+PP+DF+LR+LU ;
 SELF := Le                       
END;

ParaCustom := PROJECT(ParaIDX,CalcScore(LEFT));

Res := IF(Parms.I_Want_Paradise = TRUE,
          SORT(ParaIDX,ParadiseScore),
          SORT(ParaCustom,ParadiseScore));
   
RETURN Sequential(OUTPUT('Hello Judges Welcome To India !!'),OUTPUT(Res));   
   
END;   