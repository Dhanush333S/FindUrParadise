EXPORT File_Composite :=Module

  Export CrimeScoreRec:=RECORD
  String18 state_ut;
  REAL Kill_Ratio;
  REAL Hurt_Ratio;
  DECIMAL5_2 Kill_Score;
  DECIMAL5_2 HURT_Score;
  end;
  
  
  EXPORT CrimeScoreDS := DATASET('~SingleHunter::hack::output::CrimeScores',CrimeScoreRec,FLAT);

  EXPORT EduScoreRec :=Record
  String18 state_ut;  
  Real genderEdu;
  Real schoolEdu;
  Real facility;
  UNSIGNED GenderScore;
  UNSIGNED schoolScore;
  UNSIGNED facilityScore;
  End;
  
  EXPORT EduScoreDS := DATASET('~SingleHunter::hack::output::EducationScore',EduScoreRec,FLAT);
  
  EXPORT PovertyScoreRec:=RECORD
    STRING18 state;
    UNSIGNED4 rural;
    UNSIGNED4 urban;
    UNSIGNED4 ruralScore;
    UNSIGNED4 urbanScore;
  END;
  
  EXPORT PovertyScoreDS := DATASET('~SingleHunter::hack::output::PovertyScore',PovertyScoreRec,FLAT); 
  
  EXPORT Layout:=RECORD
    String18 state_ut;
    
    UNSIGNED5 ParadiseScore;  
    
    REAL Kill_Ratio;
    REAL Hurt_Ratio;
    DECIMAL5_2 Kill_Score;
    DECIMAL5_2 HURT_Score;
    
    Real genderEdu;
    Real schoolEdu;
    Real facility;
    UNSIGNED GenderScore;
    UNSIGNED schoolScore;
    UNSIGNED facilityScore;
    
    UNSIGNED4 rural;
    UNSIGNED4 urban;
    UNSIGNED4 ruralScore;
    UNSIGNED4 urbanScore;
        
  END;  
  EXPORT File    := DATASET('~singlehunter::hack::output::ParadiseScores',Layout,THOR);
  EXPORT IDX     := INDEX(File,{ParadiseScore},{File},'~singlehunter::hack::output::ParadiseIndex');
  EXPORT BLD_IDX := BUILD(IDX,OVERWRITE);
end;