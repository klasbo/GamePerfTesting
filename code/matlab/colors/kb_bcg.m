function colors = kb_bcg(ncolors)

    cm = [
        0.10292257 0.28253360 0.47327729
        0.10342763 0.28559479 0.47191630
        0.10403905 0.28859873 0.47073636
        0.10469657 0.29157167 0.46964121
        0.10537824 0.29452290 0.46859878
        0.10608156 0.29745353 0.46760886
        0.10681039 0.30036218 0.46668124
        0.10755099 0.30325429 0.46579763
        0.10830466 0.30612936 0.46496364
        0.10906764 0.30898884 0.46417683
        0.10983226 0.31183552 0.46342887
        0.11060063 0.31466858 0.46272622
        0.11137175 0.31748841 0.46207032
        0.11213584 0.32029836 0.46144995
        0.11289536 0.32309752 0.46087159
        0.11364498 0.32588765 0.46033046
        0.11438651 0.32866813 0.45983161
        0.11510698 0.33144303 0.45936030
        0.11581447 0.33420973 0.45892970
        0.11650430 0.33696968 0.45853587
        0.11716512 0.33972617 0.45816710
        0.11780375 0.34247709 0.45783403
        0.11841617 0.34522358 0.45753376
        0.11899870 0.34796661 0.45726397
        0.11954987 0.35070652 0.45702479
        0.12006183 0.35344532 0.45680965
        0.12053626 0.35618244 0.45662221
        0.12096962 0.35891871 0.45646055
        0.12136131 0.36165418 0.45632559
        0.12170716 0.36438978 0.45621481
        0.12200353 0.36712625 0.45612635
        0.12225010 0.36986355 0.45606134
        0.12244278 0.37260248 0.45601751
        0.12257890 0.37534350 0.45599395
        0.12267485 0.37808458 0.45599174
        0.12275919 0.38082350 0.45600289
        0.12282379 0.38356204 0.45602098
        0.12286752 0.38630051 0.45604511
        0.12288917 0.38903921 0.45607428
        0.12288812 0.39177832 0.45610788
        0.12286324 0.39451812 0.45614490
        0.12281383 0.39725882 0.45618458
        0.12273888 0.40000065 0.45622592
        0.12263747 0.40274386 0.45626791
        0.12250979 0.40548853 0.45630970
        0.12235443 0.40823490 0.45635053
        0.12217070 0.41098314 0.45638952
        0.12195798 0.41373343 0.45642572
        0.12171545 0.41648595 0.45645801
        0.12144300 0.41924079 0.45648567
        0.12114050 0.42199802 0.45650794
        0.12080750 0.42475777 0.45652379
        0.12044348 0.42752019 0.45653214
        0.12004906 0.43028527 0.45653223
        0.11962496 0.43305298 0.45652332
        0.11917022 0.43582351 0.45650434
        0.11868489 0.43859690 0.45647431
        0.11816955 0.44137314 0.45643256
        0.11762472 0.44415223 0.45637831
        0.11705010 0.44693427 0.45631026
        0.11644691 0.44971918 0.45622792
        0.11581588 0.45250693 0.45613048
        0.11515722 0.45529759 0.45601677
        0.11447231 0.45809104 0.45588621
        0.11376237 0.46088723 0.45573807
        0.11302790 0.46368619 0.45557117
        0.11227084 0.46648778 0.45538502
        0.11149273 0.46929192 0.45517889
        0.11069450 0.47209862 0.45495159
        0.10987887 0.47490768 0.45470286
        0.10904720 0.47771907 0.45443161
        0.10820188 0.48053267 0.45413721
        0.10734556 0.48334831 0.45381910
        0.10648074 0.48616593 0.45347615
        0.10561847 0.48898476 0.45310808
        0.10475370 0.49180529 0.45271396
        0.10388998 0.49462734 0.45229327
        0.10303080 0.49745076 0.45184537
        0.10217961 0.50027542 0.45136948
        0.10134088 0.50310112 0.45086523
        0.10051815 0.50592775 0.45033165
        0.09971671 0.50875507 0.44976859
        0.09894037 0.51158299 0.44917497
        0.09819526 0.51441121 0.44855077
        0.09749946 0.51723878 0.44789492
        0.09684617 0.52006627 0.44720743
        0.09624010 0.52289359 0.44648723
        0.09568801 0.52572043 0.44573433
        0.09519515 0.52854670 0.44494777
        0.09476835 0.53137210 0.44412747
        0.09441340 0.53419650 0.44327267
        0.09414015 0.53701946 0.44238313
        0.09396739 0.53984006 0.44145846
        0.09388638 0.54265897 0.44049808
        0.09390357 0.54547597 0.43950174
        0.09394420 0.54829534 0.43846959
        0.09392484 0.55112147 0.43740570
        0.09384869 0.55395406 0.43631053
        0.09371579 0.55679317 0.43518242
        0.09352769 0.55963867 0.43402080
        0.09328616 0.56249043 0.43282528
        0.09299332 0.56534824 0.43159577
        0.09264986 0.56821207 0.43033122
        0.09225759 0.57108175 0.42903140
        0.09181726 0.57395723 0.42769541
        0.09133054 0.57683835 0.42632297
        0.09079809 0.57972505 0.42491319
        0.09022017 0.58261732 0.42346493
        0.08959863 0.58551497 0.42197813
        0.08893537 0.58841783 0.42045276
        0.08823050 0.59132589 0.41888764
        0.08748607 0.59423894 0.41728288
        0.08670215 0.59715699 0.41563734
        0.08588031 0.60007987 0.41395082
        0.08502129 0.60300753 0.41222263
        0.08412581 0.60593988 0.41045205
        0.08319550 0.60887679 0.40863894
        0.08223019 0.61181825 0.40678205
        0.08123093 0.61476418 0.40488089
        0.08019870 0.61771447 0.40293491
        0.07913481 0.62066902 0.40094374
        0.07804046 0.62362772 0.39890695
        0.07691585 0.62659055 0.39682347
        0.07576251 0.62955740 0.39469303
        0.07458118 0.63252820 0.39251486
        0.07337218 0.63550294 0.39028790
        0.07213757 0.63848145 0.38801211
        0.07087741 0.64146374 0.38568622
        0.06959250 0.64444976 0.38330938
        0.06828491 0.64743937 0.38088140
        0.06695469 0.65043258 0.37840089
        0.06560281 0.65342935 0.37586696
        0.06423119 0.65642956 0.37327916
        0.06284052 0.65943319 0.37063627
        0.06143144 0.66244023 0.36793703
        0.06000605 0.66545057 0.36518085
        0.05856546 0.66846418 0.36236653
        0.05711080 0.67148103 0.35949278
        0.05564306 0.67450112 0.35655813
        0.05416553 0.67752429 0.35356223
        0.05267832 0.68055060 0.35050289
        0.05118359 0.68358000 0.34737888
        0.04968297 0.68661246 0.34418854
        0.04817997 0.68964787 0.34093103
        0.04667538 0.69268629 0.33760389
        0.04517189 0.69572765 0.33420547
        0.04367195 0.69877194 0.33073377
        0.04217957 0.70181908 0.32718734
        0.04069689 0.70486908 0.32356354
        0.03921720 0.70792194 0.31985989
        0.03778115 0.71097760 0.31607407
        0.03639573 0.71403605 0.31220332
        0.03506449 0.71709723 0.30824533
        0.03378837 0.72016117 0.30419626
        0.03257035 0.72322784 0.30005303
        0.03139831 0.72629782 0.29580401
        0.03084884 0.72935859 0.29146310
        0.03099311 0.73240963 0.28700711
        0.03188821 0.73544990 0.28243485
        0.03358958 0.73847847 0.27774229
        0.03615368 0.74149464 0.27291892
        0.03970398 0.74449577 0.26797069
        0.04410002 0.74748197 0.26288454
        0.04917476 0.75045225 0.25765039
        0.05486481 0.75340527 0.25226264
        0.06110071 0.75633979 0.24671157
        0.06782087 0.75925459 0.24098254
        0.07500565 0.76214681 0.23507702
        0.08267605 0.76501213 0.22899730
        0.09069976 0.76785223 0.22270727
        0.09905103 0.77066527 0.21618786
        0.10781679 0.77344374 0.20946073
        0.11690644 0.77618836 0.20248558
        0.12630611 0.77889673 0.19523255
        0.13609894 0.78156011 0.18772776
        0.14617596 0.78418105 0.17990106
        0.15665586 0.78674797 0.17177906
        0.16745867 0.78926135 0.16330374
        0.17862106 0.79171410 0.15445133
        0.19018952 0.79409674 0.14524080
        0.20212147 0.79640680 0.13560774
        0.21443175 0.79863666 0.12553934
        0.22712356 0.80077892 0.11503007
        0.24019239 0.80282645 0.10407642
        0.25360947 0.80477389 0.09270186
        0.26733700 0.80661715 0.08093942
        0.28131211 0.80835524 0.06886298
        0.29545830 0.80999009 0.05658755
        0.30968499 0.81152716 0.04429940
        0.32389417 0.81297533 0.03265003
        0.33799170 0.81434583 0.02346736
        0.35190187 0.81565000 0.01699052
        0.36554803 0.81690213 0.01314299
        0.37887584 0.81811547 0.01179557
        0.39185418 0.81930109 0.01280792
        0.40446803 0.82046830 0.01601782
        0.41674638 0.82162132 0.02096198
        0.42867205 0.82277669 0.02638448
        0.44028616 0.82393253 0.03232070
        0.45161197 0.82508922 0.03881229
        0.46267289 0.82624653 0.04561546
        0.47348277 0.82740552 0.05236498
        0.48406046 0.82856590 0.05910606
        0.49441641 0.82972863 0.06586787
        0.50456165 0.83089428 0.07267670
        0.51450013 0.83206446 0.07956925
        0.52424519 0.83323895 0.08654690
        0.53380326 0.83441857 0.09362489
        0.54317603 0.83560497 0.10082461
        0.55235981 0.83680079 0.10817440
        0.56136655 0.83800549 0.11566230
        0.57018344 0.83922348 0.12332906
        0.57882020 0.84045456 0.13115957
        0.58725968 0.84170414 0.13919239
        0.59550802 0.84297282 0.14741217
        0.60355333 0.84426502 0.15583771
        0.61138458 0.84558517 0.16448009
        0.61899751 0.84693630 0.17333171
        0.62638100 0.84832311 0.18239417
        0.63352458 0.84975022 0.19166589
        0.64041699 0.85122265 0.20113948
        0.64704882 0.85274502 0.21080473
        0.65341113 0.85432204 0.22064533
        0.65961806 0.85592992 0.23042320
        0.66573058 0.85755567 0.24004334
        0.67175089 0.85919944 0.24952596
        0.67768100 0.86086141 0.25888821
        0.68352291 0.86254171 0.26814470
        0.68927857 0.86424048 0.27730795
        0.69494984 0.86595783 0.28638867
        0.70053860 0.86769386 0.29539627
        0.70604662 0.86944865 0.30433874
        0.71147571 0.87122226 0.31322323
        0.71682760 0.87301474 0.32205583
        0.72210401 0.87482612 0.33084197
        0.72730666 0.87665642 0.33958641
        0.73243719 0.87850564 0.34829324
        0.73749730 0.88037376 0.35696618
        0.74248862 0.88226075 0.36560844
        0.74741203 0.88416675 0.37422400
        0.75226980 0.88609153 0.38281439
        0.75706352 0.88803504 0.39138158
        0.76179483 0.88999716 0.39992762
        0.76646525 0.89197782 0.40845408
        0.77108050 0.89397510 0.41697228
        0.77568246 0.89597712 0.42545406
        0.78028267 0.89798193 0.43386801
        0.78488142 0.89998948 0.44221862
        0.78948013 0.90199922 0.45051353
        0.79407702 0.90401212 0.45874998
        0.79867385 0.90602745 0.46693617
        0.80327094 0.90804514 0.47507555
        0.80786760 0.91006566 0.48316812
        0.81246629 0.91208787 0.49122354
        0.81707031 0.91411019 0.49925369
        0.82171245 0.91611594 0.50736038
    ];
    cmsize = size(cm, 1);
    colors = interp1(1:cmsize, cm, linspace(1, cmsize, ncolors));

end