function colors = kb_bgy_dark(ncolors)

    cm = [
        0.23792204 0.12997432 0.28282052
        0.23808826 0.13425807 0.28648681
        0.23833267 0.13842451 0.29011920
        0.23857568 0.14253023 0.29374954
        0.23880731 0.14658493 0.29738394
        0.23902685 0.15059204 0.30102495
        0.23923211 0.15455547 0.30467567
        0.23941764 0.15848043 0.30834042
        0.23958238 0.16236938 0.31202180
        0.23972817 0.16622306 0.31572116
        0.23985841 0.17004141 0.31943906
        0.23996972 0.17382765 0.32317865
        0.24005382 0.17758703 0.32694514
        0.24012020 0.18131621 0.33073603
        0.24015820 0.18502117 0.33455737
        0.24016927 0.18870208 0.33840979
        0.24015728 0.19235821 0.34229256
        0.24011077 0.19599511 0.34621184
        0.24002985 0.19961330 0.35016839
        0.23991677 0.20321244 0.35416159
        0.23976723 0.20679479 0.35819385
        0.23957872 0.21036171 0.36226647
        0.23934697 0.21391516 0.36638155
        0.23906702 0.21745717 0.37054138
        0.23873669 0.22098866 0.37474668
        0.23835414 0.22451042 0.37899773
        0.23791576 0.22802373 0.38329558
        0.23741781 0.23152987 0.38764122
        0.23685665 0.23502994 0.39203536
        0.23622863 0.23852500 0.39647858
        0.23552916 0.24201628 0.40097179
        0.23475094 0.24550565 0.40551731
        0.23389012 0.24899389 0.41011531
        0.23294324 0.25248157 0.41476554
        0.23190581 0.25596949 0.41946817
        0.23077244 0.25945857 0.42422368
        0.22953864 0.26294942 0.42903182
        0.22819777 0.26644305 0.43389337
        0.22674468 0.26994000 0.43880804
        0.22516111 0.27344364 0.44378262
        0.22347702 0.27697160 0.44864918
        0.22164504 0.28053245 0.45343518
        0.21966003 0.28412784 0.45812710
        0.21752365 0.28775789 0.46270793
        0.21523312 0.29142371 0.46716234
        0.21279220 0.29512490 0.47147252
        0.21020241 0.29886157 0.47562174
        0.20747045 0.30263262 0.47959225
        0.20460556 0.30643644 0.48336681
        0.20161968 0.31027077 0.48692906
        0.19852854 0.31413260 0.49026388
        0.19535155 0.31801815 0.49335805
        0.19211248 0.32192278 0.49620082
        0.18883858 0.32584121 0.49878452
        0.18556005 0.32976771 0.50110498
        0.18230932 0.33369623 0.50316179
        0.17912008 0.33762064 0.50495838
        0.17602612 0.34153497 0.50650182
        0.17306019 0.34543363 0.50780252
        0.17025283 0.34931158 0.50887363
        0.16763143 0.35316448 0.50973050
        0.16521968 0.35698874 0.51039005
        0.16303665 0.36078160 0.51087000
        0.16109635 0.36454121 0.51118815
        0.15940832 0.36826641 0.51136210
        0.15798013 0.37195609 0.51141048
        0.15681061 0.37561077 0.51134842
        0.15589900 0.37923046 0.51119275
        0.15527140 0.38281505 0.51093141
        0.15490617 0.38636550 0.51059317
        0.15477919 0.38988407 0.51019752
        0.15487755 0.39337217 0.50975636
        0.15518671 0.39683139 0.50928053
        0.15570315 0.40026284 0.50877170
        0.15646808 0.40366550 0.50819974
        0.15739967 0.40704419 0.50761721
        0.15848029 0.41040080 0.50703125
        0.15971592 0.41373603 0.50643262
        0.16114329 0.41704886 0.50579178
        0.16267212 0.42034486 0.50516256
        0.16428725 0.42362548 0.50455136
        0.16607849 0.42688681 0.50389187
        0.16793239 0.43013597 0.50325164
        0.16983446 0.43337425 0.50263760
        0.17188205 0.43659721 0.50197646
        0.17395085 0.43981228 0.50134835
        0.17606938 0.44301900 0.50072515
        0.17826855 0.44621581 0.50008401
        0.18045774 0.44940907 0.49947874
        0.18272883 0.45259377 0.49884286
        0.18499684 0.45577568 0.49822981
        0.18728330 0.45895415 0.49762006
        0.18960180 0.46212897 0.49699888
        0.19188919 0.46530485 0.49640535
        0.19423400 0.46847647 0.49577460
        0.19652193 0.47165186 0.49518318
        0.19886239 0.47482430 0.49454971
        0.20114788 0.47800157 0.49394639
        0.20346046 0.48117860 0.49331098
        0.20572865 0.48436070 0.49269210
        0.20800757 0.48754457 0.49204597
        0.21024674 0.49073408 0.49140732
        0.21248808 0.49392676 0.49074136
        0.21468934 0.49712589 0.49007799
        0.21689089 0.50032908 0.48938281
        0.21904799 0.50353968 0.48868921
        0.22120935 0.50675468 0.48795586
        0.22331880 0.50997809 0.48722753
        0.22544103 0.51320597 0.48644656
        0.22750088 0.51644347 0.48567642
        0.22958629 0.51968509 0.48483785
        0.23160872 0.52293674 0.48400865
        0.23364947 0.52619320 0.48311523
        0.23564396 0.52945882 0.48221535
        0.23763773 0.53273096 0.48126392
        0.23960872 0.53601105 0.48028152
        0.24156037 0.53929862 0.47926821
        0.24351500 0.54259269 0.47819726
        0.24542920 0.54589580 0.47711411
        0.24737424 0.54920368 0.47594482
        0.24928102 0.55252024 0.47476404
        0.25120113 0.55584281 0.47351253
        0.25311178 0.55917214 0.47222139
        0.25501161 0.56250849 0.47088993
        0.25693399 0.56585009 0.46947860
        0.25883346 0.56919875 0.46804820
        0.26076458 0.57255214 0.46652598
        0.26269042 0.57591139 0.46496625
        0.26462042 0.57927629 0.46335364
        0.26658125 0.58264521 0.46165694
        0.26853256 0.58601990 0.45993122
        0.27052272 0.58939799 0.45811171
        0.27252305 0.59278053 0.45624052
        0.27453105 0.59616746 0.45432278
        0.27658872 0.59955675 0.45229971
        0.27864432 0.60295278 0.45021693
        0.28072958 0.60635021 0.44808016
        0.28284295 0.60974971 0.44588266
        0.28495222 0.61315994 0.44357265
        0.28712989 0.61656238 0.44125035
        0.28931242 0.61997386 0.43881682
        0.29152894 0.62338690 0.43631224
        0.29379456 0.62679809 0.43375068
        0.29606781 0.63021821 0.43106743
        0.29842076 0.63362880 0.42836700
        0.30079014 0.63704661 0.42554599
        0.30321207 0.64046219 0.42265886
        0.30568584 0.64387624 0.41969504
        0.30818800 0.64729494 0.41661353
        0.31077428 0.65070337 0.41350759
        0.31338047 0.65411950 0.41025131
        0.31607337 0.65752485 0.40696775
        0.31880212 0.66093358 0.40355599
        0.32160120 0.66433638 0.40007488
        0.32445857 0.66773680 0.39649409
        0.32737421 0.67113481 0.39281030
        0.33036633 0.67452533 0.38905635
        0.33340864 0.67791600 0.38516890
        0.33654114 0.68129536 0.38123076
        0.33972006 0.68467633 0.37713351
        0.34299861 0.68804337 0.37299543
        0.34632408 0.69141207 0.36868351
        0.34975411 0.69476522 0.36433467
        0.35323582 0.69811886 0.35980467
        0.35682291 0.70145666 0.35522819
        0.36047073 0.70479241 0.35047383
        0.36422068 0.70811326 0.34564980
        0.36804496 0.71142816 0.34066132
        0.37196451 0.71473044 0.33556166
        0.37597582 0.71802116 0.33033046
        0.38007148 0.72130283 0.32492931
        0.38428057 0.72456579 0.31944616
        0.38856868 0.72782220 0.31372924
        0.39298145 0.73105615 0.30794264
        0.39748841 0.73427813 0.30195143
        0.40210043 0.73748518 0.29575914
        0.40684168 0.74066807 0.28946528
        0.41168831 0.74383640 0.28291461
        0.41665841 0.74698333 0.27617057
        0.42176770 0.75010338 0.26927351
        0.42700301 0.75320245 0.26209709
        0.43237159 0.75627778 0.25464009
        0.43790621 0.75931721 0.24703427
        0.44359242 0.76232707 0.23912823
        0.44944040 0.76530421 0.23090094
        0.45546241 0.76824462 0.22233822
        0.46167451 0.77114354 0.21341523
        0.46809902 0.77399226 0.20419519
        0.47474318 0.77678974 0.19456064
        0.48162539 0.77952985 0.18447712
        0.48877017 0.78220480 0.17390066
        0.49620510 0.78480557 0.16278135
        0.50395954 0.78732198 0.15106732
        0.51207611 0.78973723 0.13885569
        0.52058908 0.79203913 0.12606636
        0.52953529 0.79421312 0.11264773
        0.53895404 0.79623810 0.09890710
        0.54886748 0.79809565 0.08535901
        0.55924527 0.79977891 0.07288879
        0.56997961 0.80130017 0.06294158
        0.58089195 0.80268667 0.05809402
        0.59172860 0.80400163 0.05938805
        0.60227160 0.80530809 0.06627580
        0.61239469 0.80664810 0.07738936
        0.62205071 0.80805110 0.09067902
        0.63125100 0.80952611 0.10504035
        0.64003044 0.81107805 0.11955294
        0.64844131 0.81269807 0.13410139
        0.65652841 0.81438126 0.14846298
        0.66432931 0.81612424 0.16247911
        0.67187968 0.81792105 0.17615087
        0.67921127 0.81976599 0.18949326
        0.68634707 0.82165560 0.20251570
        0.69331241 0.82358478 0.21524401
        0.70012311 0.82555135 0.22768809
        0.70679949 0.82754888 0.23994276
        0.71336998 0.82956924 0.25204608
        0.71991310 0.83159403 0.26383180
        0.72643918 0.83362147 0.27530393
        0.73294835 0.83565191 0.28649813
        0.73944130 0.83768545 0.29744521
        0.74591327 0.83972450 0.30815817
        0.75236651 0.84176852 0.31866329
        0.75880610 0.84381576 0.32898983
        0.76523058 0.84586721 0.33914910
        0.77164215 0.84792229 0.34915878
        0.77803967 0.84998185 0.35902716
        0.78442386 0.85204596 0.36876532
        0.79079622 0.85411431 0.37838483
        0.79715639 0.85618741 0.38789205
        0.80350483 0.85826542 0.39729432
        0.80984220 0.86034839 0.40659858
        0.81616914 0.86243637 0.41581105
        0.82248631 0.86452942 0.42493739
        0.82879503 0.86662724 0.43398417
        0.83509603 0.86872982 0.44295612
        0.84138992 0.87083721 0.45185744
        0.84767666 0.87294973 0.46069059
        0.85395055 0.87507052 0.46944631
        0.86022081 0.87719542 0.47814536
        0.86648952 0.87932370 0.48679358
        0.87275219 0.88145787 0.49538341
        0.87900547 0.88359997 0.50390961
        0.88526464 0.88574259 0.51240361
        0.89151024 0.88789590 0.52082799
        0.89776483 0.89004870 0.52922790
        0.90400697 0.89221228 0.53756221
        0.91025364 0.89437819 0.54586461
        0.91650284 0.89654773 0.55413164
        0.92275187 0.89872257 0.56235855
        0.92900273 0.90090193 0.57054954
        0.93526131 0.90308295 0.57871606
        0.94152276 0.90526844 0.58684912
        0.94779853 0.90745247 0.59497036
        0.95409627 0.90963105 0.60309388
        0.96050056 0.91175810 0.61137533
    ];
    cmsize = size(cm, 1);
    colors = interp1(1:cmsize, cm, linspace(1, cmsize, ncolors));

end