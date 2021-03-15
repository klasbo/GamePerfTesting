function colors = kb_bmrygcw(ncolors)

    cm = [
        0.08060657 0.22456473 0.71347976
        0.11458385 0.22046784 0.71926202
        0.14047854 0.21637838 0.72520733
        0.16260738 0.21201020 0.73144717
        0.18230834 0.20731675 0.73798593
        0.20040356 0.20219812 0.74485674
        0.21724349 0.19663694 0.75203997
        0.23314665 0.19055392 0.75954623
        0.24830444 0.18388070 0.76737184
        0.26294571 0.17645549 0.77555559
        0.27709965 0.16822135 0.78406131
        0.29090414 0.15897229 0.79291539
        0.30424743 0.14930932 0.80111320
        0.31719953 0.13959037 0.80805630
        0.32975171 0.12978644 0.81390853
        0.34186152 0.12026087 0.81839710
        0.35354897 0.11088703 0.82183240
        0.36479536 0.10199014 0.82406424
        0.37561904 0.09361661 0.82523908
        0.38604370 0.08577770 0.82551377
        0.39606684 0.07887918 0.82475381
        0.40573381 0.07276997 0.82322600
        0.41507227 0.06749397 0.82102409
        0.42410221 0.06320038 0.81816370
        0.43284694 0.05998038 0.81468135
        0.44134333 0.05763303 0.81074721
        0.44961736 0.05610289 0.80641868
        0.45769234 0.05530878 0.80174995
        0.46559067 0.05514855 0.79679005
        0.47333161 0.05551155 0.79158548
        0.48093554 0.05629209 0.78616794
        0.48841914 0.05739580 0.78056485
        0.49580139 0.05867004 0.77483538
        0.50309703 0.06002973 0.76900586
        0.51031966 0.06140163 0.76309885
        0.51748100 0.06273152 0.75712964
        0.52458942 0.06400408 0.75109452
        0.53165860 0.06513925 0.74502365
        0.53869690 0.06609906 0.73893095
        0.54565683 0.06712548 0.73276709
        0.55255174 0.06823292 0.72648760
        0.55938575 0.06940323 0.72009745
        0.56616308 0.07061851 0.71360120
        0.57288775 0.07186158 0.70700348
        0.57956363 0.07311608 0.70030894
        0.58618752 0.07441341 0.69350219
        0.59275650 0.07577625 0.68657326
        0.59928829 0.07710351 0.67955837
        0.60578605 0.07838294 0.67246184
        0.61225330 0.07960259 0.66528644
        0.61869373 0.08075104 0.65803396
        0.62511004 0.08181846 0.65070805
        0.63149396 0.08286296 0.64328167
        0.63784777 0.08387933 0.63575319
        0.64418677 0.08478481 0.62815491
        0.65051334 0.08557180 0.62048860
        0.65683011 0.08623255 0.61275465
        0.66313966 0.08675935 0.60495276
        0.66941931 0.08728744 0.59702150
        0.67569492 0.08767292 0.58901940
        0.68196967 0.08790170 0.58094909
        0.68824531 0.08796666 0.57280999
        0.69451683 0.08789852 0.56458480
        0.70077165 0.08777140 0.55623721
        0.70703193 0.08745723 0.54781871
        0.71329893 0.08694747 0.53932799
        0.71957185 0.08624405 0.53075867
        0.72582741 0.08548260 0.52204713
        0.73209293 0.08449621 0.51325922
        0.73836907 0.08327263 0.50439347
        0.74464856 0.08184716 0.49542775
        0.75091935 0.08028742 0.48632651
        0.75720232 0.07844669 0.47714376
        0.76349752 0.07630433 0.46787868
        0.76978385 0.07398622 0.45846822
        0.77607688 0.07136479 0.44895201
        0.78238297 0.06836010 0.43934811
        0.78868829 0.06503508 0.42961733
        0.79499243 0.06135606 0.41975078
        0.80121861 0.05772826 0.40978112
        0.80725835 0.05495686 0.39962457
        0.81300076 0.05384924 0.38935763
        0.81856499 0.05376597 0.37891692
        0.82392247 0.05490624 0.36832673
        0.82895390 0.05796601 0.35767527
        0.83366135 0.06275732 0.34698149
        0.83809085 0.06877762 0.33623784
        0.84221962 0.07592055 0.32548547
        0.84602866 0.08404501 0.31476780
        0.84938754 0.09349513 0.30421381
        0.85239545 0.10356288 0.29379181
        0.85505877 0.11406690 0.28353603
        0.85737883 0.12488819 0.27348544
        0.85936288 0.13591988 0.26367270
        0.86094538 0.14729188 0.25418571
        0.86216508 0.15881846 0.24502793
        0.86309347 0.17028059 0.23616958
        0.86375342 0.18162794 0.22761390
        0.86416799 0.19282309 0.21935846
        0.86420026 0.20416608 0.21153668
        0.86403204 0.21527415 0.20400061
        0.86368901 0.22613181 0.19673028
        0.86312724 0.23684826 0.18976613
        0.86230389 0.24750987 0.18315251
        0.86137100 0.25787926 0.17674885
        0.86029001 0.26805009 0.17057654
        0.85896667 0.27817883 0.16473861
        0.85758503 0.28801247 0.15903542
        0.85603893 0.29772253 0.15358198
        0.85433928 0.30730656 0.14834832
        0.85262816 0.31659869 0.14318621
        0.85064597 0.32593607 0.13837178
        0.84867445 0.33498681 0.13358324
        0.84652930 0.34398128 0.12902467
        0.84432060 0.35280326 0.12456553
        0.84201413 0.36150136 0.12024693
        0.83959295 0.37010145 0.11607936
        0.83711609 0.37855150 0.11198477
        0.83449819 0.38694305 0.10806959
        0.83184370 0.39518176 0.10419346
        0.82904435 0.40337504 0.10049912
        0.82620460 0.41143249 0.09684352
        0.82323985 0.41943436 0.09334579
        0.82020615 0.42733617 0.08991978
        0.81708396 0.43515892 0.08659153
        0.81384308 0.44292991 0.08340741
        0.81057165 0.45058304 0.08022669
        0.80711884 0.45823686 0.07731202
        0.80360348 0.46580880 0.07417853
        0.80003792 0.47327685 0.07157820
        0.79634301 0.48072014 0.06872622
        0.79256759 0.48808990 0.06629917
        0.78866928 0.49542719 0.06383568
        0.78467278 0.50270815 0.06172858
        0.78055500 0.50995296 0.05979082
        0.77631981 0.51715677 0.05817606
        0.77196088 0.52432366 0.05691179
        0.76746888 0.53145972 0.05598407
        0.76284521 0.53856160 0.05553761
        0.75807720 0.54563763 0.05549179
        0.75316668 0.55268385 0.05597984
        0.74810415 0.55970496 0.05697976
        0.74287894 0.56670575 0.05846166
        0.73749857 0.57367765 0.06060977
        0.73193032 0.58064084 0.06307853
        0.72620974 0.58756642 0.06640717
        0.72026662 0.59449907 0.06979748
        0.71418069 0.60138045 0.07427924
        0.70785232 0.60827158 0.07882384
        0.70133316 0.61513374 0.08406821
        0.69459291 0.62198199 0.08971404
        0.68759986 0.62882883 0.09560026
        0.68040974 0.63563552 0.10228075
        0.67294041 0.64244479 0.10908365
        0.66522023 0.64923244 0.11638178
        0.65725009 0.65599290 0.12417655
        0.64896898 0.66275119 0.13214900
        0.64042517 0.66947494 0.14066752
        0.63159712 0.67616921 0.14961010
        0.62243280 0.68285109 0.15878184
        0.61296988 0.68949556 0.16839658
        0.60322350 0.69608952 0.17852980
        0.59313462 0.70265284 0.18892857
        0.58270102 0.70917877 0.19961480
        0.57200746 0.71562622 0.21089724
        0.56099872 0.72201354 0.22252794
        0.54966637 0.72833894 0.23445271
        0.53802133 0.73459355 0.24667544
        0.52616763 0.74073790 0.25941184
        0.51407070 0.74678380 0.27248531
        0.50172718 0.75273156 0.28581888
        0.48916177 0.75857305 0.29939773
        0.47645308 0.76428613 0.31329110
        0.46368424 0.76985145 0.32753951
        0.45079904 0.77528985 0.34195567
        0.43782822 0.78059745 0.35651231
        0.42480479 0.78577101 0.37118474
        0.41196835 0.79076186 0.38617444
        0.39916224 0.79561625 0.40121179
        0.38617292 0.80037448 0.41624840
        0.37287073 0.80506067 0.43118390
        0.35951116 0.80963434 0.44603981
        0.34587732 0.81412686 0.46082608
        0.33195793 0.81853679 0.47555555
        0.31776609 0.82285954 0.49023978
        0.30332679 0.82708985 0.50488584
        0.28894327 0.83119362 0.51950381
        0.27443171 0.83519389 0.53409533
        0.25983990 0.83908690 0.54866730
        0.24526888 0.84286623 0.56321637
        0.23083991 0.84652597 0.57774481
        0.21672065 0.85005996 0.59224928
        0.20312812 0.85346223 0.60672572
        0.19034390 0.85672698 0.62116604
        0.17896830 0.85983393 0.63556224
        0.16919319 0.86279380 0.64990075
        0.16146279 0.86560318 0.66417050
        0.15623705 0.86825870 0.67835569
        0.15390169 0.87075800 0.69244012
        0.15468908 0.87309981 0.70640730
        0.15862360 0.87528411 0.72023937
        0.16551774 0.87731215 0.73391840
        0.17502300 0.87918646 0.74742727
        0.18670664 0.88091094 0.76074878
        0.20012324 0.88249063 0.77386793
        0.21486203 0.88393164 0.78677153
        0.23056756 0.88524129 0.79944723
        0.24694636 0.88642761 0.81188568
        0.26376356 0.88749906 0.82408113
        0.28083322 0.88846491 0.83602620
        0.29821300 0.88931452 0.84771241
        0.31556815 0.89007646 0.85914478
        0.33281293 0.89075985 0.87032850
        0.34987183 0.89137537 0.88126479
        0.36669644 0.89193150 0.89196395
        0.38335523 0.89241149 0.90254190
        0.39963216 0.89285628 0.91292599
        0.41565017 0.89325775 0.92308926
        0.43152766 0.89360584 0.93299948
        0.44738436 0.89388777 0.94261869
        0.46333534 0.89408972 0.95189688
        0.47949272 0.89419672 0.96077037
        0.49598218 0.89418916 0.96916597
        0.51290752 0.89405080 0.97698375
        0.53046139 0.89376305 0.98395424
        0.54868808 0.89331794 0.98993445
        0.56762366 0.89272125 0.99465572
        0.58713259 0.89201009 0.99790253
        0.60701003 0.89125692 0.99933442
        0.62673208 0.89056615 0.99908938
        0.64583466 0.89004000 0.99736248
        0.66406999 0.88974601 0.99429277
        0.68117835 0.88971337 0.99045008
        0.69722662 0.88993664 0.98595933
        0.71221751 0.89039683 0.98119556
        0.72629091 0.89106876 0.97621451
        0.73954899 0.89192767 0.97112384
        0.75205661 0.89295333 0.96606360
        0.76390679 0.89412547 0.96107313
        0.77518352 0.89542573 0.95617582
        0.78616997 0.89677843 0.95129310
        0.79684021 0.89817202 0.94665359
        0.80721076 0.89960683 0.94225269
        0.81729613 0.90108334 0.93808638
        0.82711592 0.90260049 0.93414385
        0.83666814 0.90416213 0.93043543
        0.84594076 0.90577461 0.92698091
        0.85498076 0.90742983 0.92373463
        0.86377653 0.90913405 0.92070975
        0.87230892 0.91089611 0.91792235
        0.88058280 0.91271981 0.91535183
        0.88858533 0.91461555 0.91297644
        0.89627198 0.91660609 0.91077124
        0.90362807 0.91871431 0.90860178
        0.91063146 0.92097567 0.90623595
        0.91761743 0.92334408 0.90287020
    ];
    cmsize = size(cm, 1);
    colors = interp1(1:cmsize, cm, linspace(1, cmsize, ncolors));

end