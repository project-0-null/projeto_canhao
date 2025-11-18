;main.asm
global _start; o ponto de entrada é sempre global

extern read_theta ;declaração de função externa


segment dados
    SENO_TABLE DW 0, 17, 35, 52, 70, 87, 105, 122, 139, 156
    DW 174, 191, 208, 225, 242, 259, 276, 292, 309, 326
    DW 342, 358, 375, 391, 407, 423, 438, 454, 469, 485
    DW 500, 515, 530, 545, 559, 574, 588, 602, 616, 629
    DW 643, 656, 669, 682, 695, 707, 719, 731, 743, 755
    DW 766, 777, 788, 799, 809, 819, 829, 839, 848, 857
    DW 866, 875, 883, 891, 899, 906, 914, 921, 927, 934
    DW 940, 946, 951, 956, 961, 966, 970, 974, 978, 982
    DW 985, 988, 990, 993, 995, 996, 998, 999, 999, 1000


section code
..start:
call read_theta
SENO_TABLE[ax]
    