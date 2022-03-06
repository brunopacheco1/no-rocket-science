       IDENTIFICATION DIVISION.
       PROGRAM-ID. MISSION-000.
       AUTHOR. BRUNO PACHECO.
      *******************************************
      *                MISSION-000              *
      *******************************************

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT MISSIONFILE ASSIGN TO "mission-000.dat"
            FILE STATUS IS FILE-CHECK-KEY
            ORGANIZATION IS LINE SEQUENTIAL.
                     
       DATA DIVISION.
       FILE SECTION.
       FD  MISSIONFILE.

       WORKING-STORAGE SECTION.
       01  WS-WORK-AREAS.
           05 FILE-CHECK-KEY    PIC X(2).

       PROCEDURE DIVISION.
       
       0000-START.
           PERFORM 0001-READ-MISSIONFILE.
           STOP RUN.
       0001-END.

       0001-READ-MISSIONFILE.
           DISPLAY "Reading mission-000.dat...".
           DISPLAY "Finished.".
       0001-END.

       END PROGRAM MISSION-000.