
user/_usertests：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00005097          	auipc	ra,0x5
      14:	6da080e7          	jalr	1754(ra) # 56ea <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00005097          	auipc	ra,0x5
      26:	6c8080e7          	jalr	1736(ra) # 56ea <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	eba50513          	addi	a0,a0,-326 # 5ef8 <malloc+0x418>
      46:	00006097          	auipc	ra,0x6
      4a:	9dc080e7          	jalr	-1572(ra) # 5a22 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	65a080e7          	jalr	1626(ra) # 56aa <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	00009797          	auipc	a5,0x9
      5c:	41878793          	addi	a5,a5,1048 # 9470 <uninit>
      60:	0000c697          	auipc	a3,0xc
      64:	b2068693          	addi	a3,a3,-1248 # bb80 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	e9850513          	addi	a0,a0,-360 # 5f18 <malloc+0x438>
      88:	00006097          	auipc	ra,0x6
      8c:	99a080e7          	jalr	-1638(ra) # 5a22 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	618080e7          	jalr	1560(ra) # 56aa <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	e8850513          	addi	a0,a0,-376 # 5f30 <malloc+0x450>
      b0:	00005097          	auipc	ra,0x5
      b4:	63a080e7          	jalr	1594(ra) # 56ea <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	616080e7          	jalr	1558(ra) # 56d2 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	e8a50513          	addi	a0,a0,-374 # 5f50 <malloc+0x470>
      ce:	00005097          	auipc	ra,0x5
      d2:	61c080e7          	jalr	1564(ra) # 56ea <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	e5250513          	addi	a0,a0,-430 # 5f38 <malloc+0x458>
      ee:	00006097          	auipc	ra,0x6
      f2:	934080e7          	jalr	-1740(ra) # 5a22 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	5b2080e7          	jalr	1458(ra) # 56aa <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	e5e50513          	addi	a0,a0,-418 # 5f60 <malloc+0x480>
     10a:	00006097          	auipc	ra,0x6
     10e:	918080e7          	jalr	-1768(ra) # 5a22 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	596080e7          	jalr	1430(ra) # 56aa <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	e5c50513          	addi	a0,a0,-420 # 5f88 <malloc+0x4a8>
     134:	00005097          	auipc	ra,0x5
     138:	5c6080e7          	jalr	1478(ra) # 56fa <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	e4850513          	addi	a0,a0,-440 # 5f88 <malloc+0x4a8>
     148:	00005097          	auipc	ra,0x5
     14c:	5a2080e7          	jalr	1442(ra) # 56ea <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	e4458593          	addi	a1,a1,-444 # 5f98 <malloc+0x4b8>
     15c:	00005097          	auipc	ra,0x5
     160:	56e080e7          	jalr	1390(ra) # 56ca <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	e2050513          	addi	a0,a0,-480 # 5f88 <malloc+0x4a8>
     170:	00005097          	auipc	ra,0x5
     174:	57a080e7          	jalr	1402(ra) # 56ea <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	e2458593          	addi	a1,a1,-476 # 5fa0 <malloc+0x4c0>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	544080e7          	jalr	1348(ra) # 56ca <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	df450513          	addi	a0,a0,-524 # 5f88 <malloc+0x4a8>
     19c:	00005097          	auipc	ra,0x5
     1a0:	55e080e7          	jalr	1374(ra) # 56fa <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	52c080e7          	jalr	1324(ra) # 56d2 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	522080e7          	jalr	1314(ra) # 56d2 <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	dde50513          	addi	a0,a0,-546 # 5fa8 <malloc+0x4c8>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	850080e7          	jalr	-1968(ra) # 5a22 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	4ce080e7          	jalr	1230(ra) # 56aa <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00005097          	auipc	ra,0x5
     214:	4da080e7          	jalr	1242(ra) # 56ea <open>
    close(fd);
     218:	00005097          	auipc	ra,0x5
     21c:	4ba080e7          	jalr	1210(ra) # 56d2 <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	andi	s1,s1,255
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00005097          	auipc	ra,0x5
     24a:	4b4080e7          	jalr	1204(ra) # 56fa <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	andi	s1,s1,255
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	b1c50513          	addi	a0,a0,-1252 # 5d98 <malloc+0x2b8>
     284:	00005097          	auipc	ra,0x5
     288:	476080e7          	jalr	1142(ra) # 56fa <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	b08a8a93          	addi	s5,s5,-1272 # 5d98 <malloc+0x2b8>
      int cc = write(fd, buf, sz);
     298:	0000ca17          	auipc	s4,0xc
     29c:	8e8a0a13          	addi	s4,s4,-1816 # bb80 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x171>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00005097          	auipc	ra,0x5
     2b0:	43e080e7          	jalr	1086(ra) # 56ea <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00005097          	auipc	ra,0x5
     2c2:	40c080e7          	jalr	1036(ra) # 56ca <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49463          	bne	s1,a0,330 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00005097          	auipc	ra,0x5
     2d6:	3f8080e7          	jalr	1016(ra) # 56ca <write>
      if(cc != sz){
     2da:	04951963          	bne	a0,s1,32c <bigwrite+0xc8>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00005097          	auipc	ra,0x5
     2e4:	3f2080e7          	jalr	1010(ra) # 56d2 <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00005097          	auipc	ra,0x5
     2ee:	410080e7          	jalr	1040(ra) # 56fa <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	cbe50513          	addi	a0,a0,-834 # 5fd0 <malloc+0x4f0>
     31a:	00005097          	auipc	ra,0x5
     31e:	708080e7          	jalr	1800(ra) # 5a22 <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00005097          	auipc	ra,0x5
     328:	386080e7          	jalr	902(ra) # 56aa <exit>
     32c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     32e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     330:	86ce                	mv	a3,s3
     332:	8626                	mv	a2,s1
     334:	85de                	mv	a1,s7
     336:	00006517          	auipc	a0,0x6
     33a:	cba50513          	addi	a0,a0,-838 # 5ff0 <malloc+0x510>
     33e:	00005097          	auipc	ra,0x5
     342:	6e4080e7          	jalr	1764(ra) # 5a22 <printf>
        exit(1);
     346:	4505                	li	a0,1
     348:	00005097          	auipc	ra,0x5
     34c:	362080e7          	jalr	866(ra) # 56aa <exit>

0000000000000350 <copyin>:
{
     350:	715d                	addi	sp,sp,-80
     352:	e486                	sd	ra,72(sp)
     354:	e0a2                	sd	s0,64(sp)
     356:	fc26                	sd	s1,56(sp)
     358:	f84a                	sd	s2,48(sp)
     35a:	f44e                	sd	s3,40(sp)
     35c:	f052                	sd	s4,32(sp)
     35e:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     360:	4785                	li	a5,1
     362:	07fe                	slli	a5,a5,0x1f
     364:	fcf43023          	sd	a5,-64(s0)
     368:	57fd                	li	a5,-1
     36a:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     36e:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     372:	00006a17          	auipc	s4,0x6
     376:	c96a0a13          	addi	s4,s4,-874 # 6008 <malloc+0x528>
    uint64 addr = addrs[ai];
     37a:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     37e:	20100593          	li	a1,513
     382:	8552                	mv	a0,s4
     384:	00005097          	auipc	ra,0x5
     388:	366080e7          	jalr	870(ra) # 56ea <open>
     38c:	84aa                	mv	s1,a0
    if(fd < 0){
     38e:	08054863          	bltz	a0,41e <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     392:	6609                	lui	a2,0x2
     394:	85ce                	mv	a1,s3
     396:	00005097          	auipc	ra,0x5
     39a:	334080e7          	jalr	820(ra) # 56ca <write>
    if(n >= 0){
     39e:	08055d63          	bgez	a0,438 <copyin+0xe8>
    close(fd);
     3a2:	8526                	mv	a0,s1
     3a4:	00005097          	auipc	ra,0x5
     3a8:	32e080e7          	jalr	814(ra) # 56d2 <close>
    unlink("copyin1");
     3ac:	8552                	mv	a0,s4
     3ae:	00005097          	auipc	ra,0x5
     3b2:	34c080e7          	jalr	844(ra) # 56fa <unlink>
    n = write(1, (char*)addr, 8192);
     3b6:	6609                	lui	a2,0x2
     3b8:	85ce                	mv	a1,s3
     3ba:	4505                	li	a0,1
     3bc:	00005097          	auipc	ra,0x5
     3c0:	30e080e7          	jalr	782(ra) # 56ca <write>
    if(n > 0){
     3c4:	08a04963          	bgtz	a0,456 <copyin+0x106>
    if(pipe(fds) < 0){
     3c8:	fb840513          	addi	a0,s0,-72
     3cc:	00005097          	auipc	ra,0x5
     3d0:	2ee080e7          	jalr	750(ra) # 56ba <pipe>
     3d4:	0a054063          	bltz	a0,474 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3d8:	6609                	lui	a2,0x2
     3da:	85ce                	mv	a1,s3
     3dc:	fbc42503          	lw	a0,-68(s0)
     3e0:	00005097          	auipc	ra,0x5
     3e4:	2ea080e7          	jalr	746(ra) # 56ca <write>
    if(n > 0){
     3e8:	0aa04363          	bgtz	a0,48e <copyin+0x13e>
    close(fds[0]);
     3ec:	fb842503          	lw	a0,-72(s0)
     3f0:	00005097          	auipc	ra,0x5
     3f4:	2e2080e7          	jalr	738(ra) # 56d2 <close>
    close(fds[1]);
     3f8:	fbc42503          	lw	a0,-68(s0)
     3fc:	00005097          	auipc	ra,0x5
     400:	2d6080e7          	jalr	726(ra) # 56d2 <close>
  for(int ai = 0; ai < 2; ai++){
     404:	0921                	addi	s2,s2,8
     406:	fd040793          	addi	a5,s0,-48
     40a:	f6f918e3          	bne	s2,a5,37a <copyin+0x2a>
}
     40e:	60a6                	ld	ra,72(sp)
     410:	6406                	ld	s0,64(sp)
     412:	74e2                	ld	s1,56(sp)
     414:	7942                	ld	s2,48(sp)
     416:	79a2                	ld	s3,40(sp)
     418:	7a02                	ld	s4,32(sp)
     41a:	6161                	addi	sp,sp,80
     41c:	8082                	ret
      printf("open(copyin1) failed\n");
     41e:	00006517          	auipc	a0,0x6
     422:	bf250513          	addi	a0,a0,-1038 # 6010 <malloc+0x530>
     426:	00005097          	auipc	ra,0x5
     42a:	5fc080e7          	jalr	1532(ra) # 5a22 <printf>
      exit(1);
     42e:	4505                	li	a0,1
     430:	00005097          	auipc	ra,0x5
     434:	27a080e7          	jalr	634(ra) # 56aa <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     438:	862a                	mv	a2,a0
     43a:	85ce                	mv	a1,s3
     43c:	00006517          	auipc	a0,0x6
     440:	bec50513          	addi	a0,a0,-1044 # 6028 <malloc+0x548>
     444:	00005097          	auipc	ra,0x5
     448:	5de080e7          	jalr	1502(ra) # 5a22 <printf>
      exit(1);
     44c:	4505                	li	a0,1
     44e:	00005097          	auipc	ra,0x5
     452:	25c080e7          	jalr	604(ra) # 56aa <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     456:	862a                	mv	a2,a0
     458:	85ce                	mv	a1,s3
     45a:	00006517          	auipc	a0,0x6
     45e:	bfe50513          	addi	a0,a0,-1026 # 6058 <malloc+0x578>
     462:	00005097          	auipc	ra,0x5
     466:	5c0080e7          	jalr	1472(ra) # 5a22 <printf>
      exit(1);
     46a:	4505                	li	a0,1
     46c:	00005097          	auipc	ra,0x5
     470:	23e080e7          	jalr	574(ra) # 56aa <exit>
      printf("pipe() failed\n");
     474:	00006517          	auipc	a0,0x6
     478:	c1450513          	addi	a0,a0,-1004 # 6088 <malloc+0x5a8>
     47c:	00005097          	auipc	ra,0x5
     480:	5a6080e7          	jalr	1446(ra) # 5a22 <printf>
      exit(1);
     484:	4505                	li	a0,1
     486:	00005097          	auipc	ra,0x5
     48a:	224080e7          	jalr	548(ra) # 56aa <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     48e:	862a                	mv	a2,a0
     490:	85ce                	mv	a1,s3
     492:	00006517          	auipc	a0,0x6
     496:	c0650513          	addi	a0,a0,-1018 # 6098 <malloc+0x5b8>
     49a:	00005097          	auipc	ra,0x5
     49e:	588080e7          	jalr	1416(ra) # 5a22 <printf>
      exit(1);
     4a2:	4505                	li	a0,1
     4a4:	00005097          	auipc	ra,0x5
     4a8:	206080e7          	jalr	518(ra) # 56aa <exit>

00000000000004ac <copyout>:
{
     4ac:	711d                	addi	sp,sp,-96
     4ae:	ec86                	sd	ra,88(sp)
     4b0:	e8a2                	sd	s0,80(sp)
     4b2:	e4a6                	sd	s1,72(sp)
     4b4:	e0ca                	sd	s2,64(sp)
     4b6:	fc4e                	sd	s3,56(sp)
     4b8:	f852                	sd	s4,48(sp)
     4ba:	f456                	sd	s5,40(sp)
     4bc:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4be:	4785                	li	a5,1
     4c0:	07fe                	slli	a5,a5,0x1f
     4c2:	faf43823          	sd	a5,-80(s0)
     4c6:	57fd                	li	a5,-1
     4c8:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     4cc:	fb040913          	addi	s2,s0,-80
    int fd = open("README.md", 0);
     4d0:	00006a17          	auipc	s4,0x6
     4d4:	bf8a0a13          	addi	s4,s4,-1032 # 60c8 <malloc+0x5e8>
    n = write(fds[1], "x", 1);
     4d8:	00006a97          	auipc	s5,0x6
     4dc:	ac8a8a93          	addi	s5,s5,-1336 # 5fa0 <malloc+0x4c0>
    uint64 addr = addrs[ai];
     4e0:	00093983          	ld	s3,0(s2)
    int fd = open("README.md", 0);
     4e4:	4581                	li	a1,0
     4e6:	8552                	mv	a0,s4
     4e8:	00005097          	auipc	ra,0x5
     4ec:	202080e7          	jalr	514(ra) # 56ea <open>
     4f0:	84aa                	mv	s1,a0
    if(fd < 0){
     4f2:	08054663          	bltz	a0,57e <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     4f6:	6609                	lui	a2,0x2
     4f8:	85ce                	mv	a1,s3
     4fa:	00005097          	auipc	ra,0x5
     4fe:	1c8080e7          	jalr	456(ra) # 56c2 <read>
    if(n > 0){
     502:	08a04b63          	bgtz	a0,598 <copyout+0xec>
    close(fd);
     506:	8526                	mv	a0,s1
     508:	00005097          	auipc	ra,0x5
     50c:	1ca080e7          	jalr	458(ra) # 56d2 <close>
    if(pipe(fds) < 0){
     510:	fa840513          	addi	a0,s0,-88
     514:	00005097          	auipc	ra,0x5
     518:	1a6080e7          	jalr	422(ra) # 56ba <pipe>
     51c:	08054d63          	bltz	a0,5b6 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     520:	4605                	li	a2,1
     522:	85d6                	mv	a1,s5
     524:	fac42503          	lw	a0,-84(s0)
     528:	00005097          	auipc	ra,0x5
     52c:	1a2080e7          	jalr	418(ra) # 56ca <write>
    if(n != 1){
     530:	4785                	li	a5,1
     532:	08f51f63          	bne	a0,a5,5d0 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     536:	6609                	lui	a2,0x2
     538:	85ce                	mv	a1,s3
     53a:	fa842503          	lw	a0,-88(s0)
     53e:	00005097          	auipc	ra,0x5
     542:	184080e7          	jalr	388(ra) # 56c2 <read>
    if(n > 0){
     546:	0aa04263          	bgtz	a0,5ea <copyout+0x13e>
    close(fds[0]);
     54a:	fa842503          	lw	a0,-88(s0)
     54e:	00005097          	auipc	ra,0x5
     552:	184080e7          	jalr	388(ra) # 56d2 <close>
    close(fds[1]);
     556:	fac42503          	lw	a0,-84(s0)
     55a:	00005097          	auipc	ra,0x5
     55e:	178080e7          	jalr	376(ra) # 56d2 <close>
  for(int ai = 0; ai < 2; ai++){
     562:	0921                	addi	s2,s2,8
     564:	fc040793          	addi	a5,s0,-64
     568:	f6f91ce3          	bne	s2,a5,4e0 <copyout+0x34>
}
     56c:	60e6                	ld	ra,88(sp)
     56e:	6446                	ld	s0,80(sp)
     570:	64a6                	ld	s1,72(sp)
     572:	6906                	ld	s2,64(sp)
     574:	79e2                	ld	s3,56(sp)
     576:	7a42                	ld	s4,48(sp)
     578:	7aa2                	ld	s5,40(sp)
     57a:	6125                	addi	sp,sp,96
     57c:	8082                	ret
      printf("open(README.md) failed\n");
     57e:	00006517          	auipc	a0,0x6
     582:	b5a50513          	addi	a0,a0,-1190 # 60d8 <malloc+0x5f8>
     586:	00005097          	auipc	ra,0x5
     58a:	49c080e7          	jalr	1180(ra) # 5a22 <printf>
      exit(1);
     58e:	4505                	li	a0,1
     590:	00005097          	auipc	ra,0x5
     594:	11a080e7          	jalr	282(ra) # 56aa <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     598:	862a                	mv	a2,a0
     59a:	85ce                	mv	a1,s3
     59c:	00006517          	auipc	a0,0x6
     5a0:	b5450513          	addi	a0,a0,-1196 # 60f0 <malloc+0x610>
     5a4:	00005097          	auipc	ra,0x5
     5a8:	47e080e7          	jalr	1150(ra) # 5a22 <printf>
      exit(1);
     5ac:	4505                	li	a0,1
     5ae:	00005097          	auipc	ra,0x5
     5b2:	0fc080e7          	jalr	252(ra) # 56aa <exit>
      printf("pipe() failed\n");
     5b6:	00006517          	auipc	a0,0x6
     5ba:	ad250513          	addi	a0,a0,-1326 # 6088 <malloc+0x5a8>
     5be:	00005097          	auipc	ra,0x5
     5c2:	464080e7          	jalr	1124(ra) # 5a22 <printf>
      exit(1);
     5c6:	4505                	li	a0,1
     5c8:	00005097          	auipc	ra,0x5
     5cc:	0e2080e7          	jalr	226(ra) # 56aa <exit>
      printf("pipe write failed\n");
     5d0:	00006517          	auipc	a0,0x6
     5d4:	b5050513          	addi	a0,a0,-1200 # 6120 <malloc+0x640>
     5d8:	00005097          	auipc	ra,0x5
     5dc:	44a080e7          	jalr	1098(ra) # 5a22 <printf>
      exit(1);
     5e0:	4505                	li	a0,1
     5e2:	00005097          	auipc	ra,0x5
     5e6:	0c8080e7          	jalr	200(ra) # 56aa <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5ea:	862a                	mv	a2,a0
     5ec:	85ce                	mv	a1,s3
     5ee:	00006517          	auipc	a0,0x6
     5f2:	b4a50513          	addi	a0,a0,-1206 # 6138 <malloc+0x658>
     5f6:	00005097          	auipc	ra,0x5
     5fa:	42c080e7          	jalr	1068(ra) # 5a22 <printf>
      exit(1);
     5fe:	4505                	li	a0,1
     600:	00005097          	auipc	ra,0x5
     604:	0aa080e7          	jalr	170(ra) # 56aa <exit>

0000000000000608 <truncate1>:
{
     608:	711d                	addi	sp,sp,-96
     60a:	ec86                	sd	ra,88(sp)
     60c:	e8a2                	sd	s0,80(sp)
     60e:	e4a6                	sd	s1,72(sp)
     610:	e0ca                	sd	s2,64(sp)
     612:	fc4e                	sd	s3,56(sp)
     614:	f852                	sd	s4,48(sp)
     616:	f456                	sd	s5,40(sp)
     618:	1080                	addi	s0,sp,96
     61a:	8aaa                	mv	s5,a0
  unlink("truncfile");
     61c:	00006517          	auipc	a0,0x6
     620:	96c50513          	addi	a0,a0,-1684 # 5f88 <malloc+0x4a8>
     624:	00005097          	auipc	ra,0x5
     628:	0d6080e7          	jalr	214(ra) # 56fa <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     62c:	60100593          	li	a1,1537
     630:	00006517          	auipc	a0,0x6
     634:	95850513          	addi	a0,a0,-1704 # 5f88 <malloc+0x4a8>
     638:	00005097          	auipc	ra,0x5
     63c:	0b2080e7          	jalr	178(ra) # 56ea <open>
     640:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     642:	4611                	li	a2,4
     644:	00006597          	auipc	a1,0x6
     648:	95458593          	addi	a1,a1,-1708 # 5f98 <malloc+0x4b8>
     64c:	00005097          	auipc	ra,0x5
     650:	07e080e7          	jalr	126(ra) # 56ca <write>
  close(fd1);
     654:	8526                	mv	a0,s1
     656:	00005097          	auipc	ra,0x5
     65a:	07c080e7          	jalr	124(ra) # 56d2 <close>
  int fd2 = open("truncfile", O_RDONLY);
     65e:	4581                	li	a1,0
     660:	00006517          	auipc	a0,0x6
     664:	92850513          	addi	a0,a0,-1752 # 5f88 <malloc+0x4a8>
     668:	00005097          	auipc	ra,0x5
     66c:	082080e7          	jalr	130(ra) # 56ea <open>
     670:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     672:	02000613          	li	a2,32
     676:	fa040593          	addi	a1,s0,-96
     67a:	00005097          	auipc	ra,0x5
     67e:	048080e7          	jalr	72(ra) # 56c2 <read>
  if(n != 4){
     682:	4791                	li	a5,4
     684:	0cf51e63          	bne	a0,a5,760 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     688:	40100593          	li	a1,1025
     68c:	00006517          	auipc	a0,0x6
     690:	8fc50513          	addi	a0,a0,-1796 # 5f88 <malloc+0x4a8>
     694:	00005097          	auipc	ra,0x5
     698:	056080e7          	jalr	86(ra) # 56ea <open>
     69c:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     69e:	4581                	li	a1,0
     6a0:	00006517          	auipc	a0,0x6
     6a4:	8e850513          	addi	a0,a0,-1816 # 5f88 <malloc+0x4a8>
     6a8:	00005097          	auipc	ra,0x5
     6ac:	042080e7          	jalr	66(ra) # 56ea <open>
     6b0:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6b2:	02000613          	li	a2,32
     6b6:	fa040593          	addi	a1,s0,-96
     6ba:	00005097          	auipc	ra,0x5
     6be:	008080e7          	jalr	8(ra) # 56c2 <read>
     6c2:	8a2a                	mv	s4,a0
  if(n != 0){
     6c4:	ed4d                	bnez	a0,77e <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6c6:	02000613          	li	a2,32
     6ca:	fa040593          	addi	a1,s0,-96
     6ce:	8526                	mv	a0,s1
     6d0:	00005097          	auipc	ra,0x5
     6d4:	ff2080e7          	jalr	-14(ra) # 56c2 <read>
     6d8:	8a2a                	mv	s4,a0
  if(n != 0){
     6da:	e971                	bnez	a0,7ae <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6dc:	4619                	li	a2,6
     6de:	00006597          	auipc	a1,0x6
     6e2:	aea58593          	addi	a1,a1,-1302 # 61c8 <malloc+0x6e8>
     6e6:	854e                	mv	a0,s3
     6e8:	00005097          	auipc	ra,0x5
     6ec:	fe2080e7          	jalr	-30(ra) # 56ca <write>
  n = read(fd3, buf, sizeof(buf));
     6f0:	02000613          	li	a2,32
     6f4:	fa040593          	addi	a1,s0,-96
     6f8:	854a                	mv	a0,s2
     6fa:	00005097          	auipc	ra,0x5
     6fe:	fc8080e7          	jalr	-56(ra) # 56c2 <read>
  if(n != 6){
     702:	4799                	li	a5,6
     704:	0cf51d63          	bne	a0,a5,7de <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     708:	02000613          	li	a2,32
     70c:	fa040593          	addi	a1,s0,-96
     710:	8526                	mv	a0,s1
     712:	00005097          	auipc	ra,0x5
     716:	fb0080e7          	jalr	-80(ra) # 56c2 <read>
  if(n != 2){
     71a:	4789                	li	a5,2
     71c:	0ef51063          	bne	a0,a5,7fc <truncate1+0x1f4>
  unlink("truncfile");
     720:	00006517          	auipc	a0,0x6
     724:	86850513          	addi	a0,a0,-1944 # 5f88 <malloc+0x4a8>
     728:	00005097          	auipc	ra,0x5
     72c:	fd2080e7          	jalr	-46(ra) # 56fa <unlink>
  close(fd1);
     730:	854e                	mv	a0,s3
     732:	00005097          	auipc	ra,0x5
     736:	fa0080e7          	jalr	-96(ra) # 56d2 <close>
  close(fd2);
     73a:	8526                	mv	a0,s1
     73c:	00005097          	auipc	ra,0x5
     740:	f96080e7          	jalr	-106(ra) # 56d2 <close>
  close(fd3);
     744:	854a                	mv	a0,s2
     746:	00005097          	auipc	ra,0x5
     74a:	f8c080e7          	jalr	-116(ra) # 56d2 <close>
}
     74e:	60e6                	ld	ra,88(sp)
     750:	6446                	ld	s0,80(sp)
     752:	64a6                	ld	s1,72(sp)
     754:	6906                	ld	s2,64(sp)
     756:	79e2                	ld	s3,56(sp)
     758:	7a42                	ld	s4,48(sp)
     75a:	7aa2                	ld	s5,40(sp)
     75c:	6125                	addi	sp,sp,96
     75e:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     760:	862a                	mv	a2,a0
     762:	85d6                	mv	a1,s5
     764:	00006517          	auipc	a0,0x6
     768:	a0450513          	addi	a0,a0,-1532 # 6168 <malloc+0x688>
     76c:	00005097          	auipc	ra,0x5
     770:	2b6080e7          	jalr	694(ra) # 5a22 <printf>
    exit(1);
     774:	4505                	li	a0,1
     776:	00005097          	auipc	ra,0x5
     77a:	f34080e7          	jalr	-204(ra) # 56aa <exit>
    printf("aaa fd3=%d\n", fd3);
     77e:	85ca                	mv	a1,s2
     780:	00006517          	auipc	a0,0x6
     784:	a0850513          	addi	a0,a0,-1528 # 6188 <malloc+0x6a8>
     788:	00005097          	auipc	ra,0x5
     78c:	29a080e7          	jalr	666(ra) # 5a22 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     790:	8652                	mv	a2,s4
     792:	85d6                	mv	a1,s5
     794:	00006517          	auipc	a0,0x6
     798:	a0450513          	addi	a0,a0,-1532 # 6198 <malloc+0x6b8>
     79c:	00005097          	auipc	ra,0x5
     7a0:	286080e7          	jalr	646(ra) # 5a22 <printf>
    exit(1);
     7a4:	4505                	li	a0,1
     7a6:	00005097          	auipc	ra,0x5
     7aa:	f04080e7          	jalr	-252(ra) # 56aa <exit>
    printf("bbb fd2=%d\n", fd2);
     7ae:	85a6                	mv	a1,s1
     7b0:	00006517          	auipc	a0,0x6
     7b4:	a0850513          	addi	a0,a0,-1528 # 61b8 <malloc+0x6d8>
     7b8:	00005097          	auipc	ra,0x5
     7bc:	26a080e7          	jalr	618(ra) # 5a22 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7c0:	8652                	mv	a2,s4
     7c2:	85d6                	mv	a1,s5
     7c4:	00006517          	auipc	a0,0x6
     7c8:	9d450513          	addi	a0,a0,-1580 # 6198 <malloc+0x6b8>
     7cc:	00005097          	auipc	ra,0x5
     7d0:	256080e7          	jalr	598(ra) # 5a22 <printf>
    exit(1);
     7d4:	4505                	li	a0,1
     7d6:	00005097          	auipc	ra,0x5
     7da:	ed4080e7          	jalr	-300(ra) # 56aa <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7de:	862a                	mv	a2,a0
     7e0:	85d6                	mv	a1,s5
     7e2:	00006517          	auipc	a0,0x6
     7e6:	9ee50513          	addi	a0,a0,-1554 # 61d0 <malloc+0x6f0>
     7ea:	00005097          	auipc	ra,0x5
     7ee:	238080e7          	jalr	568(ra) # 5a22 <printf>
    exit(1);
     7f2:	4505                	li	a0,1
     7f4:	00005097          	auipc	ra,0x5
     7f8:	eb6080e7          	jalr	-330(ra) # 56aa <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     7fc:	862a                	mv	a2,a0
     7fe:	85d6                	mv	a1,s5
     800:	00006517          	auipc	a0,0x6
     804:	9f050513          	addi	a0,a0,-1552 # 61f0 <malloc+0x710>
     808:	00005097          	auipc	ra,0x5
     80c:	21a080e7          	jalr	538(ra) # 5a22 <printf>
    exit(1);
     810:	4505                	li	a0,1
     812:	00005097          	auipc	ra,0x5
     816:	e98080e7          	jalr	-360(ra) # 56aa <exit>

000000000000081a <writetest>:
{
     81a:	7139                	addi	sp,sp,-64
     81c:	fc06                	sd	ra,56(sp)
     81e:	f822                	sd	s0,48(sp)
     820:	f426                	sd	s1,40(sp)
     822:	f04a                	sd	s2,32(sp)
     824:	ec4e                	sd	s3,24(sp)
     826:	e852                	sd	s4,16(sp)
     828:	e456                	sd	s5,8(sp)
     82a:	e05a                	sd	s6,0(sp)
     82c:	0080                	addi	s0,sp,64
     82e:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     830:	20200593          	li	a1,514
     834:	00006517          	auipc	a0,0x6
     838:	9dc50513          	addi	a0,a0,-1572 # 6210 <malloc+0x730>
     83c:	00005097          	auipc	ra,0x5
     840:	eae080e7          	jalr	-338(ra) # 56ea <open>
  if(fd < 0){
     844:	0a054d63          	bltz	a0,8fe <writetest+0xe4>
     848:	892a                	mv	s2,a0
     84a:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     84c:	00006997          	auipc	s3,0x6
     850:	9ec98993          	addi	s3,s3,-1556 # 6238 <malloc+0x758>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     854:	00006a97          	auipc	s5,0x6
     858:	a1ca8a93          	addi	s5,s5,-1508 # 6270 <malloc+0x790>
  for(i = 0; i < N; i++){
     85c:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     860:	4629                	li	a2,10
     862:	85ce                	mv	a1,s3
     864:	854a                	mv	a0,s2
     866:	00005097          	auipc	ra,0x5
     86a:	e64080e7          	jalr	-412(ra) # 56ca <write>
     86e:	47a9                	li	a5,10
     870:	0af51563          	bne	a0,a5,91a <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     874:	4629                	li	a2,10
     876:	85d6                	mv	a1,s5
     878:	854a                	mv	a0,s2
     87a:	00005097          	auipc	ra,0x5
     87e:	e50080e7          	jalr	-432(ra) # 56ca <write>
     882:	47a9                	li	a5,10
     884:	0af51a63          	bne	a0,a5,938 <writetest+0x11e>
  for(i = 0; i < N; i++){
     888:	2485                	addiw	s1,s1,1
     88a:	fd449be3          	bne	s1,s4,860 <writetest+0x46>
  close(fd);
     88e:	854a                	mv	a0,s2
     890:	00005097          	auipc	ra,0x5
     894:	e42080e7          	jalr	-446(ra) # 56d2 <close>
  fd = open("small", O_RDONLY);
     898:	4581                	li	a1,0
     89a:	00006517          	auipc	a0,0x6
     89e:	97650513          	addi	a0,a0,-1674 # 6210 <malloc+0x730>
     8a2:	00005097          	auipc	ra,0x5
     8a6:	e48080e7          	jalr	-440(ra) # 56ea <open>
     8aa:	84aa                	mv	s1,a0
  if(fd < 0){
     8ac:	0a054563          	bltz	a0,956 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     8b0:	7d000613          	li	a2,2000
     8b4:	0000b597          	auipc	a1,0xb
     8b8:	2cc58593          	addi	a1,a1,716 # bb80 <buf>
     8bc:	00005097          	auipc	ra,0x5
     8c0:	e06080e7          	jalr	-506(ra) # 56c2 <read>
  if(i != N*SZ*2){
     8c4:	7d000793          	li	a5,2000
     8c8:	0af51563          	bne	a0,a5,972 <writetest+0x158>
  close(fd);
     8cc:	8526                	mv	a0,s1
     8ce:	00005097          	auipc	ra,0x5
     8d2:	e04080e7          	jalr	-508(ra) # 56d2 <close>
  if(unlink("small") < 0){
     8d6:	00006517          	auipc	a0,0x6
     8da:	93a50513          	addi	a0,a0,-1734 # 6210 <malloc+0x730>
     8de:	00005097          	auipc	ra,0x5
     8e2:	e1c080e7          	jalr	-484(ra) # 56fa <unlink>
     8e6:	0a054463          	bltz	a0,98e <writetest+0x174>
}
     8ea:	70e2                	ld	ra,56(sp)
     8ec:	7442                	ld	s0,48(sp)
     8ee:	74a2                	ld	s1,40(sp)
     8f0:	7902                	ld	s2,32(sp)
     8f2:	69e2                	ld	s3,24(sp)
     8f4:	6a42                	ld	s4,16(sp)
     8f6:	6aa2                	ld	s5,8(sp)
     8f8:	6b02                	ld	s6,0(sp)
     8fa:	6121                	addi	sp,sp,64
     8fc:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     8fe:	85da                	mv	a1,s6
     900:	00006517          	auipc	a0,0x6
     904:	91850513          	addi	a0,a0,-1768 # 6218 <malloc+0x738>
     908:	00005097          	auipc	ra,0x5
     90c:	11a080e7          	jalr	282(ra) # 5a22 <printf>
    exit(1);
     910:	4505                	li	a0,1
     912:	00005097          	auipc	ra,0x5
     916:	d98080e7          	jalr	-616(ra) # 56aa <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     91a:	8626                	mv	a2,s1
     91c:	85da                	mv	a1,s6
     91e:	00006517          	auipc	a0,0x6
     922:	92a50513          	addi	a0,a0,-1750 # 6248 <malloc+0x768>
     926:	00005097          	auipc	ra,0x5
     92a:	0fc080e7          	jalr	252(ra) # 5a22 <printf>
      exit(1);
     92e:	4505                	li	a0,1
     930:	00005097          	auipc	ra,0x5
     934:	d7a080e7          	jalr	-646(ra) # 56aa <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     938:	8626                	mv	a2,s1
     93a:	85da                	mv	a1,s6
     93c:	00006517          	auipc	a0,0x6
     940:	94450513          	addi	a0,a0,-1724 # 6280 <malloc+0x7a0>
     944:	00005097          	auipc	ra,0x5
     948:	0de080e7          	jalr	222(ra) # 5a22 <printf>
      exit(1);
     94c:	4505                	li	a0,1
     94e:	00005097          	auipc	ra,0x5
     952:	d5c080e7          	jalr	-676(ra) # 56aa <exit>
    printf("%s: error: open small failed!\n", s);
     956:	85da                	mv	a1,s6
     958:	00006517          	auipc	a0,0x6
     95c:	95050513          	addi	a0,a0,-1712 # 62a8 <malloc+0x7c8>
     960:	00005097          	auipc	ra,0x5
     964:	0c2080e7          	jalr	194(ra) # 5a22 <printf>
    exit(1);
     968:	4505                	li	a0,1
     96a:	00005097          	auipc	ra,0x5
     96e:	d40080e7          	jalr	-704(ra) # 56aa <exit>
    printf("%s: read failed\n", s);
     972:	85da                	mv	a1,s6
     974:	00006517          	auipc	a0,0x6
     978:	95450513          	addi	a0,a0,-1708 # 62c8 <malloc+0x7e8>
     97c:	00005097          	auipc	ra,0x5
     980:	0a6080e7          	jalr	166(ra) # 5a22 <printf>
    exit(1);
     984:	4505                	li	a0,1
     986:	00005097          	auipc	ra,0x5
     98a:	d24080e7          	jalr	-732(ra) # 56aa <exit>
    printf("%s: unlink small failed\n", s);
     98e:	85da                	mv	a1,s6
     990:	00006517          	auipc	a0,0x6
     994:	95050513          	addi	a0,a0,-1712 # 62e0 <malloc+0x800>
     998:	00005097          	auipc	ra,0x5
     99c:	08a080e7          	jalr	138(ra) # 5a22 <printf>
    exit(1);
     9a0:	4505                	li	a0,1
     9a2:	00005097          	auipc	ra,0x5
     9a6:	d08080e7          	jalr	-760(ra) # 56aa <exit>

00000000000009aa <writebig>:
{
     9aa:	7139                	addi	sp,sp,-64
     9ac:	fc06                	sd	ra,56(sp)
     9ae:	f822                	sd	s0,48(sp)
     9b0:	f426                	sd	s1,40(sp)
     9b2:	f04a                	sd	s2,32(sp)
     9b4:	ec4e                	sd	s3,24(sp)
     9b6:	e852                	sd	s4,16(sp)
     9b8:	e456                	sd	s5,8(sp)
     9ba:	0080                	addi	s0,sp,64
     9bc:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9be:	20200593          	li	a1,514
     9c2:	00006517          	auipc	a0,0x6
     9c6:	93e50513          	addi	a0,a0,-1730 # 6300 <malloc+0x820>
     9ca:	00005097          	auipc	ra,0x5
     9ce:	d20080e7          	jalr	-736(ra) # 56ea <open>
     9d2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9d4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9d6:	0000b917          	auipc	s2,0xb
     9da:	1aa90913          	addi	s2,s2,426 # bb80 <buf>
  for(i = 0; i < MAXFILE; i++){
     9de:	10c00a13          	li	s4,268
  if(fd < 0){
     9e2:	06054c63          	bltz	a0,a5a <writebig+0xb0>
    ((int*)buf)[0] = i;
     9e6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9ea:	40000613          	li	a2,1024
     9ee:	85ca                	mv	a1,s2
     9f0:	854e                	mv	a0,s3
     9f2:	00005097          	auipc	ra,0x5
     9f6:	cd8080e7          	jalr	-808(ra) # 56ca <write>
     9fa:	40000793          	li	a5,1024
     9fe:	06f51c63          	bne	a0,a5,a76 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     a02:	2485                	addiw	s1,s1,1
     a04:	ff4491e3          	bne	s1,s4,9e6 <writebig+0x3c>
  close(fd);
     a08:	854e                	mv	a0,s3
     a0a:	00005097          	auipc	ra,0x5
     a0e:	cc8080e7          	jalr	-824(ra) # 56d2 <close>
  fd = open("big", O_RDONLY);
     a12:	4581                	li	a1,0
     a14:	00006517          	auipc	a0,0x6
     a18:	8ec50513          	addi	a0,a0,-1812 # 6300 <malloc+0x820>
     a1c:	00005097          	auipc	ra,0x5
     a20:	cce080e7          	jalr	-818(ra) # 56ea <open>
     a24:	89aa                	mv	s3,a0
  n = 0;
     a26:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a28:	0000b917          	auipc	s2,0xb
     a2c:	15890913          	addi	s2,s2,344 # bb80 <buf>
  if(fd < 0){
     a30:	06054263          	bltz	a0,a94 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     a34:	40000613          	li	a2,1024
     a38:	85ca                	mv	a1,s2
     a3a:	854e                	mv	a0,s3
     a3c:	00005097          	auipc	ra,0x5
     a40:	c86080e7          	jalr	-890(ra) # 56c2 <read>
    if(i == 0){
     a44:	c535                	beqz	a0,ab0 <writebig+0x106>
    } else if(i != BSIZE){
     a46:	40000793          	li	a5,1024
     a4a:	0af51f63          	bne	a0,a5,b08 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     a4e:	00092683          	lw	a3,0(s2)
     a52:	0c969a63          	bne	a3,s1,b26 <writebig+0x17c>
    n++;
     a56:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a58:	bff1                	j	a34 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     a5a:	85d6                	mv	a1,s5
     a5c:	00006517          	auipc	a0,0x6
     a60:	8ac50513          	addi	a0,a0,-1876 # 6308 <malloc+0x828>
     a64:	00005097          	auipc	ra,0x5
     a68:	fbe080e7          	jalr	-66(ra) # 5a22 <printf>
    exit(1);
     a6c:	4505                	li	a0,1
     a6e:	00005097          	auipc	ra,0x5
     a72:	c3c080e7          	jalr	-964(ra) # 56aa <exit>
      printf("%s: error: write big file failed\n", s, i);
     a76:	8626                	mv	a2,s1
     a78:	85d6                	mv	a1,s5
     a7a:	00006517          	auipc	a0,0x6
     a7e:	8ae50513          	addi	a0,a0,-1874 # 6328 <malloc+0x848>
     a82:	00005097          	auipc	ra,0x5
     a86:	fa0080e7          	jalr	-96(ra) # 5a22 <printf>
      exit(1);
     a8a:	4505                	li	a0,1
     a8c:	00005097          	auipc	ra,0x5
     a90:	c1e080e7          	jalr	-994(ra) # 56aa <exit>
    printf("%s: error: open big failed!\n", s);
     a94:	85d6                	mv	a1,s5
     a96:	00006517          	auipc	a0,0x6
     a9a:	8ba50513          	addi	a0,a0,-1862 # 6350 <malloc+0x870>
     a9e:	00005097          	auipc	ra,0x5
     aa2:	f84080e7          	jalr	-124(ra) # 5a22 <printf>
    exit(1);
     aa6:	4505                	li	a0,1
     aa8:	00005097          	auipc	ra,0x5
     aac:	c02080e7          	jalr	-1022(ra) # 56aa <exit>
      if(n == MAXFILE - 1){
     ab0:	10b00793          	li	a5,267
     ab4:	02f48a63          	beq	s1,a5,ae8 <writebig+0x13e>
  close(fd);
     ab8:	854e                	mv	a0,s3
     aba:	00005097          	auipc	ra,0x5
     abe:	c18080e7          	jalr	-1000(ra) # 56d2 <close>
  if(unlink("big") < 0){
     ac2:	00006517          	auipc	a0,0x6
     ac6:	83e50513          	addi	a0,a0,-1986 # 6300 <malloc+0x820>
     aca:	00005097          	auipc	ra,0x5
     ace:	c30080e7          	jalr	-976(ra) # 56fa <unlink>
     ad2:	06054963          	bltz	a0,b44 <writebig+0x19a>
}
     ad6:	70e2                	ld	ra,56(sp)
     ad8:	7442                	ld	s0,48(sp)
     ada:	74a2                	ld	s1,40(sp)
     adc:	7902                	ld	s2,32(sp)
     ade:	69e2                	ld	s3,24(sp)
     ae0:	6a42                	ld	s4,16(sp)
     ae2:	6aa2                	ld	s5,8(sp)
     ae4:	6121                	addi	sp,sp,64
     ae6:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     ae8:	10b00613          	li	a2,267
     aec:	85d6                	mv	a1,s5
     aee:	00006517          	auipc	a0,0x6
     af2:	88250513          	addi	a0,a0,-1918 # 6370 <malloc+0x890>
     af6:	00005097          	auipc	ra,0x5
     afa:	f2c080e7          	jalr	-212(ra) # 5a22 <printf>
        exit(1);
     afe:	4505                	li	a0,1
     b00:	00005097          	auipc	ra,0x5
     b04:	baa080e7          	jalr	-1110(ra) # 56aa <exit>
      printf("%s: read failed %d\n", s, i);
     b08:	862a                	mv	a2,a0
     b0a:	85d6                	mv	a1,s5
     b0c:	00006517          	auipc	a0,0x6
     b10:	88c50513          	addi	a0,a0,-1908 # 6398 <malloc+0x8b8>
     b14:	00005097          	auipc	ra,0x5
     b18:	f0e080e7          	jalr	-242(ra) # 5a22 <printf>
      exit(1);
     b1c:	4505                	li	a0,1
     b1e:	00005097          	auipc	ra,0x5
     b22:	b8c080e7          	jalr	-1140(ra) # 56aa <exit>
      printf("%s: read content of block %d is %d\n", s,
     b26:	8626                	mv	a2,s1
     b28:	85d6                	mv	a1,s5
     b2a:	00006517          	auipc	a0,0x6
     b2e:	88650513          	addi	a0,a0,-1914 # 63b0 <malloc+0x8d0>
     b32:	00005097          	auipc	ra,0x5
     b36:	ef0080e7          	jalr	-272(ra) # 5a22 <printf>
      exit(1);
     b3a:	4505                	li	a0,1
     b3c:	00005097          	auipc	ra,0x5
     b40:	b6e080e7          	jalr	-1170(ra) # 56aa <exit>
    printf("%s: unlink big failed\n", s);
     b44:	85d6                	mv	a1,s5
     b46:	00006517          	auipc	a0,0x6
     b4a:	89250513          	addi	a0,a0,-1902 # 63d8 <malloc+0x8f8>
     b4e:	00005097          	auipc	ra,0x5
     b52:	ed4080e7          	jalr	-300(ra) # 5a22 <printf>
    exit(1);
     b56:	4505                	li	a0,1
     b58:	00005097          	auipc	ra,0x5
     b5c:	b52080e7          	jalr	-1198(ra) # 56aa <exit>

0000000000000b60 <unlinkread>:
{
     b60:	7179                	addi	sp,sp,-48
     b62:	f406                	sd	ra,40(sp)
     b64:	f022                	sd	s0,32(sp)
     b66:	ec26                	sd	s1,24(sp)
     b68:	e84a                	sd	s2,16(sp)
     b6a:	e44e                	sd	s3,8(sp)
     b6c:	1800                	addi	s0,sp,48
     b6e:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b70:	20200593          	li	a1,514
     b74:	00005517          	auipc	a0,0x5
     b78:	1b450513          	addi	a0,a0,436 # 5d28 <malloc+0x248>
     b7c:	00005097          	auipc	ra,0x5
     b80:	b6e080e7          	jalr	-1170(ra) # 56ea <open>
  if(fd < 0){
     b84:	0e054563          	bltz	a0,c6e <unlinkread+0x10e>
     b88:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b8a:	4615                	li	a2,5
     b8c:	00006597          	auipc	a1,0x6
     b90:	88458593          	addi	a1,a1,-1916 # 6410 <malloc+0x930>
     b94:	00005097          	auipc	ra,0x5
     b98:	b36080e7          	jalr	-1226(ra) # 56ca <write>
  close(fd);
     b9c:	8526                	mv	a0,s1
     b9e:	00005097          	auipc	ra,0x5
     ba2:	b34080e7          	jalr	-1228(ra) # 56d2 <close>
  fd = open("unlinkread", O_RDWR);
     ba6:	4589                	li	a1,2
     ba8:	00005517          	auipc	a0,0x5
     bac:	18050513          	addi	a0,a0,384 # 5d28 <malloc+0x248>
     bb0:	00005097          	auipc	ra,0x5
     bb4:	b3a080e7          	jalr	-1222(ra) # 56ea <open>
     bb8:	84aa                	mv	s1,a0
  if(fd < 0){
     bba:	0c054863          	bltz	a0,c8a <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bbe:	00005517          	auipc	a0,0x5
     bc2:	16a50513          	addi	a0,a0,362 # 5d28 <malloc+0x248>
     bc6:	00005097          	auipc	ra,0x5
     bca:	b34080e7          	jalr	-1228(ra) # 56fa <unlink>
     bce:	ed61                	bnez	a0,ca6 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd0:	20200593          	li	a1,514
     bd4:	00005517          	auipc	a0,0x5
     bd8:	15450513          	addi	a0,a0,340 # 5d28 <malloc+0x248>
     bdc:	00005097          	auipc	ra,0x5
     be0:	b0e080e7          	jalr	-1266(ra) # 56ea <open>
     be4:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be6:	460d                	li	a2,3
     be8:	00006597          	auipc	a1,0x6
     bec:	87058593          	addi	a1,a1,-1936 # 6458 <malloc+0x978>
     bf0:	00005097          	auipc	ra,0x5
     bf4:	ada080e7          	jalr	-1318(ra) # 56ca <write>
  close(fd1);
     bf8:	854a                	mv	a0,s2
     bfa:	00005097          	auipc	ra,0x5
     bfe:	ad8080e7          	jalr	-1320(ra) # 56d2 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c02:	660d                	lui	a2,0x3
     c04:	0000b597          	auipc	a1,0xb
     c08:	f7c58593          	addi	a1,a1,-132 # bb80 <buf>
     c0c:	8526                	mv	a0,s1
     c0e:	00005097          	auipc	ra,0x5
     c12:	ab4080e7          	jalr	-1356(ra) # 56c2 <read>
     c16:	4795                	li	a5,5
     c18:	0af51563          	bne	a0,a5,cc2 <unlinkread+0x162>
  if(buf[0] != 'h'){
     c1c:	0000b717          	auipc	a4,0xb
     c20:	f6474703          	lbu	a4,-156(a4) # bb80 <buf>
     c24:	06800793          	li	a5,104
     c28:	0af71b63          	bne	a4,a5,cde <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c2c:	4629                	li	a2,10
     c2e:	0000b597          	auipc	a1,0xb
     c32:	f5258593          	addi	a1,a1,-174 # bb80 <buf>
     c36:	8526                	mv	a0,s1
     c38:	00005097          	auipc	ra,0x5
     c3c:	a92080e7          	jalr	-1390(ra) # 56ca <write>
     c40:	47a9                	li	a5,10
     c42:	0af51c63          	bne	a0,a5,cfa <unlinkread+0x19a>
  close(fd);
     c46:	8526                	mv	a0,s1
     c48:	00005097          	auipc	ra,0x5
     c4c:	a8a080e7          	jalr	-1398(ra) # 56d2 <close>
  unlink("unlinkread");
     c50:	00005517          	auipc	a0,0x5
     c54:	0d850513          	addi	a0,a0,216 # 5d28 <malloc+0x248>
     c58:	00005097          	auipc	ra,0x5
     c5c:	aa2080e7          	jalr	-1374(ra) # 56fa <unlink>
}
     c60:	70a2                	ld	ra,40(sp)
     c62:	7402                	ld	s0,32(sp)
     c64:	64e2                	ld	s1,24(sp)
     c66:	6942                	ld	s2,16(sp)
     c68:	69a2                	ld	s3,8(sp)
     c6a:	6145                	addi	sp,sp,48
     c6c:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c6e:	85ce                	mv	a1,s3
     c70:	00005517          	auipc	a0,0x5
     c74:	78050513          	addi	a0,a0,1920 # 63f0 <malloc+0x910>
     c78:	00005097          	auipc	ra,0x5
     c7c:	daa080e7          	jalr	-598(ra) # 5a22 <printf>
    exit(1);
     c80:	4505                	li	a0,1
     c82:	00005097          	auipc	ra,0x5
     c86:	a28080e7          	jalr	-1496(ra) # 56aa <exit>
    printf("%s: open unlinkread failed\n", s);
     c8a:	85ce                	mv	a1,s3
     c8c:	00005517          	auipc	a0,0x5
     c90:	78c50513          	addi	a0,a0,1932 # 6418 <malloc+0x938>
     c94:	00005097          	auipc	ra,0x5
     c98:	d8e080e7          	jalr	-626(ra) # 5a22 <printf>
    exit(1);
     c9c:	4505                	li	a0,1
     c9e:	00005097          	auipc	ra,0x5
     ca2:	a0c080e7          	jalr	-1524(ra) # 56aa <exit>
    printf("%s: unlink unlinkread failed\n", s);
     ca6:	85ce                	mv	a1,s3
     ca8:	00005517          	auipc	a0,0x5
     cac:	79050513          	addi	a0,a0,1936 # 6438 <malloc+0x958>
     cb0:	00005097          	auipc	ra,0x5
     cb4:	d72080e7          	jalr	-654(ra) # 5a22 <printf>
    exit(1);
     cb8:	4505                	li	a0,1
     cba:	00005097          	auipc	ra,0x5
     cbe:	9f0080e7          	jalr	-1552(ra) # 56aa <exit>
    printf("%s: unlinkread read failed", s);
     cc2:	85ce                	mv	a1,s3
     cc4:	00005517          	auipc	a0,0x5
     cc8:	79c50513          	addi	a0,a0,1948 # 6460 <malloc+0x980>
     ccc:	00005097          	auipc	ra,0x5
     cd0:	d56080e7          	jalr	-682(ra) # 5a22 <printf>
    exit(1);
     cd4:	4505                	li	a0,1
     cd6:	00005097          	auipc	ra,0x5
     cda:	9d4080e7          	jalr	-1580(ra) # 56aa <exit>
    printf("%s: unlinkread wrong data\n", s);
     cde:	85ce                	mv	a1,s3
     ce0:	00005517          	auipc	a0,0x5
     ce4:	7a050513          	addi	a0,a0,1952 # 6480 <malloc+0x9a0>
     ce8:	00005097          	auipc	ra,0x5
     cec:	d3a080e7          	jalr	-710(ra) # 5a22 <printf>
    exit(1);
     cf0:	4505                	li	a0,1
     cf2:	00005097          	auipc	ra,0x5
     cf6:	9b8080e7          	jalr	-1608(ra) # 56aa <exit>
    printf("%s: unlinkread write failed\n", s);
     cfa:	85ce                	mv	a1,s3
     cfc:	00005517          	auipc	a0,0x5
     d00:	7a450513          	addi	a0,a0,1956 # 64a0 <malloc+0x9c0>
     d04:	00005097          	auipc	ra,0x5
     d08:	d1e080e7          	jalr	-738(ra) # 5a22 <printf>
    exit(1);
     d0c:	4505                	li	a0,1
     d0e:	00005097          	auipc	ra,0x5
     d12:	99c080e7          	jalr	-1636(ra) # 56aa <exit>

0000000000000d16 <linktest>:
{
     d16:	1101                	addi	sp,sp,-32
     d18:	ec06                	sd	ra,24(sp)
     d1a:	e822                	sd	s0,16(sp)
     d1c:	e426                	sd	s1,8(sp)
     d1e:	e04a                	sd	s2,0(sp)
     d20:	1000                	addi	s0,sp,32
     d22:	892a                	mv	s2,a0
  unlink("lf1");
     d24:	00005517          	auipc	a0,0x5
     d28:	79c50513          	addi	a0,a0,1948 # 64c0 <malloc+0x9e0>
     d2c:	00005097          	auipc	ra,0x5
     d30:	9ce080e7          	jalr	-1586(ra) # 56fa <unlink>
  unlink("lf2");
     d34:	00005517          	auipc	a0,0x5
     d38:	79450513          	addi	a0,a0,1940 # 64c8 <malloc+0x9e8>
     d3c:	00005097          	auipc	ra,0x5
     d40:	9be080e7          	jalr	-1602(ra) # 56fa <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d44:	20200593          	li	a1,514
     d48:	00005517          	auipc	a0,0x5
     d4c:	77850513          	addi	a0,a0,1912 # 64c0 <malloc+0x9e0>
     d50:	00005097          	auipc	ra,0x5
     d54:	99a080e7          	jalr	-1638(ra) # 56ea <open>
  if(fd < 0){
     d58:	10054763          	bltz	a0,e66 <linktest+0x150>
     d5c:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d5e:	4615                	li	a2,5
     d60:	00005597          	auipc	a1,0x5
     d64:	6b058593          	addi	a1,a1,1712 # 6410 <malloc+0x930>
     d68:	00005097          	auipc	ra,0x5
     d6c:	962080e7          	jalr	-1694(ra) # 56ca <write>
     d70:	4795                	li	a5,5
     d72:	10f51863          	bne	a0,a5,e82 <linktest+0x16c>
  close(fd);
     d76:	8526                	mv	a0,s1
     d78:	00005097          	auipc	ra,0x5
     d7c:	95a080e7          	jalr	-1702(ra) # 56d2 <close>
  if(link("lf1", "lf2") < 0){
     d80:	00005597          	auipc	a1,0x5
     d84:	74858593          	addi	a1,a1,1864 # 64c8 <malloc+0x9e8>
     d88:	00005517          	auipc	a0,0x5
     d8c:	73850513          	addi	a0,a0,1848 # 64c0 <malloc+0x9e0>
     d90:	00005097          	auipc	ra,0x5
     d94:	97a080e7          	jalr	-1670(ra) # 570a <link>
     d98:	10054363          	bltz	a0,e9e <linktest+0x188>
  unlink("lf1");
     d9c:	00005517          	auipc	a0,0x5
     da0:	72450513          	addi	a0,a0,1828 # 64c0 <malloc+0x9e0>
     da4:	00005097          	auipc	ra,0x5
     da8:	956080e7          	jalr	-1706(ra) # 56fa <unlink>
  if(open("lf1", 0) >= 0){
     dac:	4581                	li	a1,0
     dae:	00005517          	auipc	a0,0x5
     db2:	71250513          	addi	a0,a0,1810 # 64c0 <malloc+0x9e0>
     db6:	00005097          	auipc	ra,0x5
     dba:	934080e7          	jalr	-1740(ra) # 56ea <open>
     dbe:	0e055e63          	bgez	a0,eba <linktest+0x1a4>
  fd = open("lf2", 0);
     dc2:	4581                	li	a1,0
     dc4:	00005517          	auipc	a0,0x5
     dc8:	70450513          	addi	a0,a0,1796 # 64c8 <malloc+0x9e8>
     dcc:	00005097          	auipc	ra,0x5
     dd0:	91e080e7          	jalr	-1762(ra) # 56ea <open>
     dd4:	84aa                	mv	s1,a0
  if(fd < 0){
     dd6:	10054063          	bltz	a0,ed6 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     dda:	660d                	lui	a2,0x3
     ddc:	0000b597          	auipc	a1,0xb
     de0:	da458593          	addi	a1,a1,-604 # bb80 <buf>
     de4:	00005097          	auipc	ra,0x5
     de8:	8de080e7          	jalr	-1826(ra) # 56c2 <read>
     dec:	4795                	li	a5,5
     dee:	10f51263          	bne	a0,a5,ef2 <linktest+0x1dc>
  close(fd);
     df2:	8526                	mv	a0,s1
     df4:	00005097          	auipc	ra,0x5
     df8:	8de080e7          	jalr	-1826(ra) # 56d2 <close>
  if(link("lf2", "lf2") >= 0){
     dfc:	00005597          	auipc	a1,0x5
     e00:	6cc58593          	addi	a1,a1,1740 # 64c8 <malloc+0x9e8>
     e04:	852e                	mv	a0,a1
     e06:	00005097          	auipc	ra,0x5
     e0a:	904080e7          	jalr	-1788(ra) # 570a <link>
     e0e:	10055063          	bgez	a0,f0e <linktest+0x1f8>
  unlink("lf2");
     e12:	00005517          	auipc	a0,0x5
     e16:	6b650513          	addi	a0,a0,1718 # 64c8 <malloc+0x9e8>
     e1a:	00005097          	auipc	ra,0x5
     e1e:	8e0080e7          	jalr	-1824(ra) # 56fa <unlink>
  if(link("lf2", "lf1") >= 0){
     e22:	00005597          	auipc	a1,0x5
     e26:	69e58593          	addi	a1,a1,1694 # 64c0 <malloc+0x9e0>
     e2a:	00005517          	auipc	a0,0x5
     e2e:	69e50513          	addi	a0,a0,1694 # 64c8 <malloc+0x9e8>
     e32:	00005097          	auipc	ra,0x5
     e36:	8d8080e7          	jalr	-1832(ra) # 570a <link>
     e3a:	0e055863          	bgez	a0,f2a <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e3e:	00005597          	auipc	a1,0x5
     e42:	68258593          	addi	a1,a1,1666 # 64c0 <malloc+0x9e0>
     e46:	00005517          	auipc	a0,0x5
     e4a:	78a50513          	addi	a0,a0,1930 # 65d0 <malloc+0xaf0>
     e4e:	00005097          	auipc	ra,0x5
     e52:	8bc080e7          	jalr	-1860(ra) # 570a <link>
     e56:	0e055863          	bgez	a0,f46 <linktest+0x230>
}
     e5a:	60e2                	ld	ra,24(sp)
     e5c:	6442                	ld	s0,16(sp)
     e5e:	64a2                	ld	s1,8(sp)
     e60:	6902                	ld	s2,0(sp)
     e62:	6105                	addi	sp,sp,32
     e64:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e66:	85ca                	mv	a1,s2
     e68:	00005517          	auipc	a0,0x5
     e6c:	66850513          	addi	a0,a0,1640 # 64d0 <malloc+0x9f0>
     e70:	00005097          	auipc	ra,0x5
     e74:	bb2080e7          	jalr	-1102(ra) # 5a22 <printf>
    exit(1);
     e78:	4505                	li	a0,1
     e7a:	00005097          	auipc	ra,0x5
     e7e:	830080e7          	jalr	-2000(ra) # 56aa <exit>
    printf("%s: write lf1 failed\n", s);
     e82:	85ca                	mv	a1,s2
     e84:	00005517          	auipc	a0,0x5
     e88:	66450513          	addi	a0,a0,1636 # 64e8 <malloc+0xa08>
     e8c:	00005097          	auipc	ra,0x5
     e90:	b96080e7          	jalr	-1130(ra) # 5a22 <printf>
    exit(1);
     e94:	4505                	li	a0,1
     e96:	00005097          	auipc	ra,0x5
     e9a:	814080e7          	jalr	-2028(ra) # 56aa <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e9e:	85ca                	mv	a1,s2
     ea0:	00005517          	auipc	a0,0x5
     ea4:	66050513          	addi	a0,a0,1632 # 6500 <malloc+0xa20>
     ea8:	00005097          	auipc	ra,0x5
     eac:	b7a080e7          	jalr	-1158(ra) # 5a22 <printf>
    exit(1);
     eb0:	4505                	li	a0,1
     eb2:	00004097          	auipc	ra,0x4
     eb6:	7f8080e7          	jalr	2040(ra) # 56aa <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     eba:	85ca                	mv	a1,s2
     ebc:	00005517          	auipc	a0,0x5
     ec0:	66450513          	addi	a0,a0,1636 # 6520 <malloc+0xa40>
     ec4:	00005097          	auipc	ra,0x5
     ec8:	b5e080e7          	jalr	-1186(ra) # 5a22 <printf>
    exit(1);
     ecc:	4505                	li	a0,1
     ece:	00004097          	auipc	ra,0x4
     ed2:	7dc080e7          	jalr	2012(ra) # 56aa <exit>
    printf("%s: open lf2 failed\n", s);
     ed6:	85ca                	mv	a1,s2
     ed8:	00005517          	auipc	a0,0x5
     edc:	67850513          	addi	a0,a0,1656 # 6550 <malloc+0xa70>
     ee0:	00005097          	auipc	ra,0x5
     ee4:	b42080e7          	jalr	-1214(ra) # 5a22 <printf>
    exit(1);
     ee8:	4505                	li	a0,1
     eea:	00004097          	auipc	ra,0x4
     eee:	7c0080e7          	jalr	1984(ra) # 56aa <exit>
    printf("%s: read lf2 failed\n", s);
     ef2:	85ca                	mv	a1,s2
     ef4:	00005517          	auipc	a0,0x5
     ef8:	67450513          	addi	a0,a0,1652 # 6568 <malloc+0xa88>
     efc:	00005097          	auipc	ra,0x5
     f00:	b26080e7          	jalr	-1242(ra) # 5a22 <printf>
    exit(1);
     f04:	4505                	li	a0,1
     f06:	00004097          	auipc	ra,0x4
     f0a:	7a4080e7          	jalr	1956(ra) # 56aa <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f0e:	85ca                	mv	a1,s2
     f10:	00005517          	auipc	a0,0x5
     f14:	67050513          	addi	a0,a0,1648 # 6580 <malloc+0xaa0>
     f18:	00005097          	auipc	ra,0x5
     f1c:	b0a080e7          	jalr	-1270(ra) # 5a22 <printf>
    exit(1);
     f20:	4505                	li	a0,1
     f22:	00004097          	auipc	ra,0x4
     f26:	788080e7          	jalr	1928(ra) # 56aa <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
     f2a:	85ca                	mv	a1,s2
     f2c:	00005517          	auipc	a0,0x5
     f30:	67c50513          	addi	a0,a0,1660 # 65a8 <malloc+0xac8>
     f34:	00005097          	auipc	ra,0x5
     f38:	aee080e7          	jalr	-1298(ra) # 5a22 <printf>
    exit(1);
     f3c:	4505                	li	a0,1
     f3e:	00004097          	auipc	ra,0x4
     f42:	76c080e7          	jalr	1900(ra) # 56aa <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f46:	85ca                	mv	a1,s2
     f48:	00005517          	auipc	a0,0x5
     f4c:	69050513          	addi	a0,a0,1680 # 65d8 <malloc+0xaf8>
     f50:	00005097          	auipc	ra,0x5
     f54:	ad2080e7          	jalr	-1326(ra) # 5a22 <printf>
    exit(1);
     f58:	4505                	li	a0,1
     f5a:	00004097          	auipc	ra,0x4
     f5e:	750080e7          	jalr	1872(ra) # 56aa <exit>

0000000000000f62 <bigdir>:
{
     f62:	715d                	addi	sp,sp,-80
     f64:	e486                	sd	ra,72(sp)
     f66:	e0a2                	sd	s0,64(sp)
     f68:	fc26                	sd	s1,56(sp)
     f6a:	f84a                	sd	s2,48(sp)
     f6c:	f44e                	sd	s3,40(sp)
     f6e:	f052                	sd	s4,32(sp)
     f70:	ec56                	sd	s5,24(sp)
     f72:	e85a                	sd	s6,16(sp)
     f74:	0880                	addi	s0,sp,80
     f76:	89aa                	mv	s3,a0
  unlink("bd");
     f78:	00005517          	auipc	a0,0x5
     f7c:	68050513          	addi	a0,a0,1664 # 65f8 <malloc+0xb18>
     f80:	00004097          	auipc	ra,0x4
     f84:	77a080e7          	jalr	1914(ra) # 56fa <unlink>
  fd = open("bd", O_CREATE);
     f88:	20000593          	li	a1,512
     f8c:	00005517          	auipc	a0,0x5
     f90:	66c50513          	addi	a0,a0,1644 # 65f8 <malloc+0xb18>
     f94:	00004097          	auipc	ra,0x4
     f98:	756080e7          	jalr	1878(ra) # 56ea <open>
  if(fd < 0){
     f9c:	0c054963          	bltz	a0,106e <bigdir+0x10c>
  close(fd);
     fa0:	00004097          	auipc	ra,0x4
     fa4:	732080e7          	jalr	1842(ra) # 56d2 <close>
  for(i = 0; i < N; i++){
     fa8:	4901                	li	s2,0
    name[0] = 'x';
     faa:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fae:	00005a17          	auipc	s4,0x5
     fb2:	64aa0a13          	addi	s4,s4,1610 # 65f8 <malloc+0xb18>
  for(i = 0; i < N; i++){
     fb6:	1f400b13          	li	s6,500
    name[0] = 'x';
     fba:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fbe:	41f9579b          	sraiw	a5,s2,0x1f
     fc2:	01a7d71b          	srliw	a4,a5,0x1a
     fc6:	012707bb          	addw	a5,a4,s2
     fca:	4067d69b          	sraiw	a3,a5,0x6
     fce:	0306869b          	addiw	a3,a3,48
     fd2:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fd6:	03f7f793          	andi	a5,a5,63
     fda:	9f99                	subw	a5,a5,a4
     fdc:	0307879b          	addiw	a5,a5,48
     fe0:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     fe4:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     fe8:	fb040593          	addi	a1,s0,-80
     fec:	8552                	mv	a0,s4
     fee:	00004097          	auipc	ra,0x4
     ff2:	71c080e7          	jalr	1820(ra) # 570a <link>
     ff6:	84aa                	mv	s1,a0
     ff8:	e949                	bnez	a0,108a <bigdir+0x128>
  for(i = 0; i < N; i++){
     ffa:	2905                	addiw	s2,s2,1
     ffc:	fb691fe3          	bne	s2,s6,fba <bigdir+0x58>
  unlink("bd");
    1000:	00005517          	auipc	a0,0x5
    1004:	5f850513          	addi	a0,a0,1528 # 65f8 <malloc+0xb18>
    1008:	00004097          	auipc	ra,0x4
    100c:	6f2080e7          	jalr	1778(ra) # 56fa <unlink>
    name[0] = 'x';
    1010:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1014:	1f400a13          	li	s4,500
    name[0] = 'x';
    1018:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    101c:	41f4d79b          	sraiw	a5,s1,0x1f
    1020:	01a7d71b          	srliw	a4,a5,0x1a
    1024:	009707bb          	addw	a5,a4,s1
    1028:	4067d69b          	sraiw	a3,a5,0x6
    102c:	0306869b          	addiw	a3,a3,48
    1030:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1034:	03f7f793          	andi	a5,a5,63
    1038:	9f99                	subw	a5,a5,a4
    103a:	0307879b          	addiw	a5,a5,48
    103e:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1042:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1046:	fb040513          	addi	a0,s0,-80
    104a:	00004097          	auipc	ra,0x4
    104e:	6b0080e7          	jalr	1712(ra) # 56fa <unlink>
    1052:	ed21                	bnez	a0,10aa <bigdir+0x148>
  for(i = 0; i < N; i++){
    1054:	2485                	addiw	s1,s1,1
    1056:	fd4491e3          	bne	s1,s4,1018 <bigdir+0xb6>
}
    105a:	60a6                	ld	ra,72(sp)
    105c:	6406                	ld	s0,64(sp)
    105e:	74e2                	ld	s1,56(sp)
    1060:	7942                	ld	s2,48(sp)
    1062:	79a2                	ld	s3,40(sp)
    1064:	7a02                	ld	s4,32(sp)
    1066:	6ae2                	ld	s5,24(sp)
    1068:	6b42                	ld	s6,16(sp)
    106a:	6161                	addi	sp,sp,80
    106c:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    106e:	85ce                	mv	a1,s3
    1070:	00005517          	auipc	a0,0x5
    1074:	59050513          	addi	a0,a0,1424 # 6600 <malloc+0xb20>
    1078:	00005097          	auipc	ra,0x5
    107c:	9aa080e7          	jalr	-1622(ra) # 5a22 <printf>
    exit(1);
    1080:	4505                	li	a0,1
    1082:	00004097          	auipc	ra,0x4
    1086:	628080e7          	jalr	1576(ra) # 56aa <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    108a:	fb040613          	addi	a2,s0,-80
    108e:	85ce                	mv	a1,s3
    1090:	00005517          	auipc	a0,0x5
    1094:	59050513          	addi	a0,a0,1424 # 6620 <malloc+0xb40>
    1098:	00005097          	auipc	ra,0x5
    109c:	98a080e7          	jalr	-1654(ra) # 5a22 <printf>
      exit(1);
    10a0:	4505                	li	a0,1
    10a2:	00004097          	auipc	ra,0x4
    10a6:	608080e7          	jalr	1544(ra) # 56aa <exit>
      printf("%s: bigdir unlink failed", s);
    10aa:	85ce                	mv	a1,s3
    10ac:	00005517          	auipc	a0,0x5
    10b0:	59450513          	addi	a0,a0,1428 # 6640 <malloc+0xb60>
    10b4:	00005097          	auipc	ra,0x5
    10b8:	96e080e7          	jalr	-1682(ra) # 5a22 <printf>
      exit(1);
    10bc:	4505                	li	a0,1
    10be:	00004097          	auipc	ra,0x4
    10c2:	5ec080e7          	jalr	1516(ra) # 56aa <exit>

00000000000010c6 <validatetest>:
{
    10c6:	7139                	addi	sp,sp,-64
    10c8:	fc06                	sd	ra,56(sp)
    10ca:	f822                	sd	s0,48(sp)
    10cc:	f426                	sd	s1,40(sp)
    10ce:	f04a                	sd	s2,32(sp)
    10d0:	ec4e                	sd	s3,24(sp)
    10d2:	e852                	sd	s4,16(sp)
    10d4:	e456                	sd	s5,8(sp)
    10d6:	e05a                	sd	s6,0(sp)
    10d8:	0080                	addi	s0,sp,64
    10da:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10dc:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10de:	00005997          	auipc	s3,0x5
    10e2:	58298993          	addi	s3,s3,1410 # 6660 <malloc+0xb80>
    10e6:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10e8:	6a85                	lui	s5,0x1
    10ea:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    10ee:	85a6                	mv	a1,s1
    10f0:	854e                	mv	a0,s3
    10f2:	00004097          	auipc	ra,0x4
    10f6:	618080e7          	jalr	1560(ra) # 570a <link>
    10fa:	01251f63          	bne	a0,s2,1118 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10fe:	94d6                	add	s1,s1,s5
    1100:	ff4497e3          	bne	s1,s4,10ee <validatetest+0x28>
}
    1104:	70e2                	ld	ra,56(sp)
    1106:	7442                	ld	s0,48(sp)
    1108:	74a2                	ld	s1,40(sp)
    110a:	7902                	ld	s2,32(sp)
    110c:	69e2                	ld	s3,24(sp)
    110e:	6a42                	ld	s4,16(sp)
    1110:	6aa2                	ld	s5,8(sp)
    1112:	6b02                	ld	s6,0(sp)
    1114:	6121                	addi	sp,sp,64
    1116:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1118:	85da                	mv	a1,s6
    111a:	00005517          	auipc	a0,0x5
    111e:	55650513          	addi	a0,a0,1366 # 6670 <malloc+0xb90>
    1122:	00005097          	auipc	ra,0x5
    1126:	900080e7          	jalr	-1792(ra) # 5a22 <printf>
      exit(1);
    112a:	4505                	li	a0,1
    112c:	00004097          	auipc	ra,0x4
    1130:	57e080e7          	jalr	1406(ra) # 56aa <exit>

0000000000001134 <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    1134:	7179                	addi	sp,sp,-48
    1136:	f406                	sd	ra,40(sp)
    1138:	f022                	sd	s0,32(sp)
    113a:	ec26                	sd	s1,24(sp)
    113c:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    113e:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1142:	00007497          	auipc	s1,0x7
    1146:	20e4b483          	ld	s1,526(s1) # 8350 <__SDATA_BEGIN__>
    114a:	fd840593          	addi	a1,s0,-40
    114e:	8526                	mv	a0,s1
    1150:	00004097          	auipc	ra,0x4
    1154:	592080e7          	jalr	1426(ra) # 56e2 <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    1158:	8526                	mv	a0,s1
    115a:	00004097          	auipc	ra,0x4
    115e:	560080e7          	jalr	1376(ra) # 56ba <pipe>

  exit(0);
    1162:	4501                	li	a0,0
    1164:	00004097          	auipc	ra,0x4
    1168:	546080e7          	jalr	1350(ra) # 56aa <exit>

000000000000116c <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    116c:	7139                	addi	sp,sp,-64
    116e:	fc06                	sd	ra,56(sp)
    1170:	f822                	sd	s0,48(sp)
    1172:	f426                	sd	s1,40(sp)
    1174:	f04a                	sd	s2,32(sp)
    1176:	ec4e                	sd	s3,24(sp)
    1178:	0080                	addi	s0,sp,64
    117a:	64b1                	lui	s1,0xc
    117c:	35048493          	addi	s1,s1,848 # c350 <buf+0x7d0>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1180:	597d                	li	s2,-1
    1182:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    1186:	00005997          	auipc	s3,0x5
    118a:	daa98993          	addi	s3,s3,-598 # 5f30 <malloc+0x450>
    argv[0] = (char*)0xffffffff;
    118e:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1192:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1196:	fc040593          	addi	a1,s0,-64
    119a:	854e                	mv	a0,s3
    119c:	00004097          	auipc	ra,0x4
    11a0:	546080e7          	jalr	1350(ra) # 56e2 <exec>
  for(int i = 0; i < 50000; i++){
    11a4:	34fd                	addiw	s1,s1,-1
    11a6:	f4e5                	bnez	s1,118e <badarg+0x22>
  }
  
  exit(0);
    11a8:	4501                	li	a0,0
    11aa:	00004097          	auipc	ra,0x4
    11ae:	500080e7          	jalr	1280(ra) # 56aa <exit>

00000000000011b2 <copyinstr2>:
{
    11b2:	7155                	addi	sp,sp,-208
    11b4:	e586                	sd	ra,200(sp)
    11b6:	e1a2                	sd	s0,192(sp)
    11b8:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11ba:	f6840793          	addi	a5,s0,-152
    11be:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    11c2:	07800713          	li	a4,120
    11c6:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11ca:	0785                	addi	a5,a5,1
    11cc:	fed79de3          	bne	a5,a3,11c6 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11d0:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11d4:	f6840513          	addi	a0,s0,-152
    11d8:	00004097          	auipc	ra,0x4
    11dc:	522080e7          	jalr	1314(ra) # 56fa <unlink>
  if(ret != -1){
    11e0:	57fd                	li	a5,-1
    11e2:	0ef51063          	bne	a0,a5,12c2 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11e6:	20100593          	li	a1,513
    11ea:	f6840513          	addi	a0,s0,-152
    11ee:	00004097          	auipc	ra,0x4
    11f2:	4fc080e7          	jalr	1276(ra) # 56ea <open>
  if(fd != -1){
    11f6:	57fd                	li	a5,-1
    11f8:	0ef51563          	bne	a0,a5,12e2 <copyinstr2+0x130>
  ret = link(b, b);
    11fc:	f6840593          	addi	a1,s0,-152
    1200:	852e                	mv	a0,a1
    1202:	00004097          	auipc	ra,0x4
    1206:	508080e7          	jalr	1288(ra) # 570a <link>
  if(ret != -1){
    120a:	57fd                	li	a5,-1
    120c:	0ef51b63          	bne	a0,a5,1302 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1210:	00006797          	auipc	a5,0x6
    1214:	63078793          	addi	a5,a5,1584 # 7840 <malloc+0x1d60>
    1218:	f4f43c23          	sd	a5,-168(s0)
    121c:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1220:	f5840593          	addi	a1,s0,-168
    1224:	f6840513          	addi	a0,s0,-152
    1228:	00004097          	auipc	ra,0x4
    122c:	4ba080e7          	jalr	1210(ra) # 56e2 <exec>
  if(ret != -1){
    1230:	57fd                	li	a5,-1
    1232:	0ef51963          	bne	a0,a5,1324 <copyinstr2+0x172>
  int pid = fork();
    1236:	00004097          	auipc	ra,0x4
    123a:	46c080e7          	jalr	1132(ra) # 56a2 <fork>
  if(pid < 0){
    123e:	10054363          	bltz	a0,1344 <copyinstr2+0x192>
  if(pid == 0){
    1242:	12051463          	bnez	a0,136a <copyinstr2+0x1b8>
    1246:	00007797          	auipc	a5,0x7
    124a:	22278793          	addi	a5,a5,546 # 8468 <big.1264>
    124e:	00008697          	auipc	a3,0x8
    1252:	21a68693          	addi	a3,a3,538 # 9468 <__global_pointer$+0x918>
      big[i] = 'x';
    1256:	07800713          	li	a4,120
    125a:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    125e:	0785                	addi	a5,a5,1
    1260:	fed79de3          	bne	a5,a3,125a <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1264:	00008797          	auipc	a5,0x8
    1268:	20078223          	sb	zero,516(a5) # 9468 <__global_pointer$+0x918>
    char *args2[] = { big, big, big, 0 };
    126c:	00007797          	auipc	a5,0x7
    1270:	ce478793          	addi	a5,a5,-796 # 7f50 <malloc+0x2470>
    1274:	6390                	ld	a2,0(a5)
    1276:	6794                	ld	a3,8(a5)
    1278:	6b98                	ld	a4,16(a5)
    127a:	6f9c                	ld	a5,24(a5)
    127c:	f2c43823          	sd	a2,-208(s0)
    1280:	f2d43c23          	sd	a3,-200(s0)
    1284:	f4e43023          	sd	a4,-192(s0)
    1288:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    128c:	f3040593          	addi	a1,s0,-208
    1290:	00005517          	auipc	a0,0x5
    1294:	ca050513          	addi	a0,a0,-864 # 5f30 <malloc+0x450>
    1298:	00004097          	auipc	ra,0x4
    129c:	44a080e7          	jalr	1098(ra) # 56e2 <exec>
    if(ret != -1){
    12a0:	57fd                	li	a5,-1
    12a2:	0af50e63          	beq	a0,a5,135e <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12a6:	55fd                	li	a1,-1
    12a8:	00005517          	auipc	a0,0x5
    12ac:	47050513          	addi	a0,a0,1136 # 6718 <malloc+0xc38>
    12b0:	00004097          	auipc	ra,0x4
    12b4:	772080e7          	jalr	1906(ra) # 5a22 <printf>
      exit(1);
    12b8:	4505                	li	a0,1
    12ba:	00004097          	auipc	ra,0x4
    12be:	3f0080e7          	jalr	1008(ra) # 56aa <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12c2:	862a                	mv	a2,a0
    12c4:	f6840593          	addi	a1,s0,-152
    12c8:	00005517          	auipc	a0,0x5
    12cc:	3c850513          	addi	a0,a0,968 # 6690 <malloc+0xbb0>
    12d0:	00004097          	auipc	ra,0x4
    12d4:	752080e7          	jalr	1874(ra) # 5a22 <printf>
    exit(1);
    12d8:	4505                	li	a0,1
    12da:	00004097          	auipc	ra,0x4
    12de:	3d0080e7          	jalr	976(ra) # 56aa <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12e2:	862a                	mv	a2,a0
    12e4:	f6840593          	addi	a1,s0,-152
    12e8:	00005517          	auipc	a0,0x5
    12ec:	3c850513          	addi	a0,a0,968 # 66b0 <malloc+0xbd0>
    12f0:	00004097          	auipc	ra,0x4
    12f4:	732080e7          	jalr	1842(ra) # 5a22 <printf>
    exit(1);
    12f8:	4505                	li	a0,1
    12fa:	00004097          	auipc	ra,0x4
    12fe:	3b0080e7          	jalr	944(ra) # 56aa <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1302:	86aa                	mv	a3,a0
    1304:	f6840613          	addi	a2,s0,-152
    1308:	85b2                	mv	a1,a2
    130a:	00005517          	auipc	a0,0x5
    130e:	3c650513          	addi	a0,a0,966 # 66d0 <malloc+0xbf0>
    1312:	00004097          	auipc	ra,0x4
    1316:	710080e7          	jalr	1808(ra) # 5a22 <printf>
    exit(1);
    131a:	4505                	li	a0,1
    131c:	00004097          	auipc	ra,0x4
    1320:	38e080e7          	jalr	910(ra) # 56aa <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1324:	567d                	li	a2,-1
    1326:	f6840593          	addi	a1,s0,-152
    132a:	00005517          	auipc	a0,0x5
    132e:	3ce50513          	addi	a0,a0,974 # 66f8 <malloc+0xc18>
    1332:	00004097          	auipc	ra,0x4
    1336:	6f0080e7          	jalr	1776(ra) # 5a22 <printf>
    exit(1);
    133a:	4505                	li	a0,1
    133c:	00004097          	auipc	ra,0x4
    1340:	36e080e7          	jalr	878(ra) # 56aa <exit>
    printf("fork failed\n");
    1344:	00006517          	auipc	a0,0x6
    1348:	83450513          	addi	a0,a0,-1996 # 6b78 <malloc+0x1098>
    134c:	00004097          	auipc	ra,0x4
    1350:	6d6080e7          	jalr	1750(ra) # 5a22 <printf>
    exit(1);
    1354:	4505                	li	a0,1
    1356:	00004097          	auipc	ra,0x4
    135a:	354080e7          	jalr	852(ra) # 56aa <exit>
    exit(747); // OK
    135e:	2eb00513          	li	a0,747
    1362:	00004097          	auipc	ra,0x4
    1366:	348080e7          	jalr	840(ra) # 56aa <exit>
  int st = 0;
    136a:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    136e:	f5440513          	addi	a0,s0,-172
    1372:	00004097          	auipc	ra,0x4
    1376:	340080e7          	jalr	832(ra) # 56b2 <wait>
  if(st != 747){
    137a:	f5442703          	lw	a4,-172(s0)
    137e:	2eb00793          	li	a5,747
    1382:	00f71663          	bne	a4,a5,138e <copyinstr2+0x1dc>
}
    1386:	60ae                	ld	ra,200(sp)
    1388:	640e                	ld	s0,192(sp)
    138a:	6169                	addi	sp,sp,208
    138c:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    138e:	00005517          	auipc	a0,0x5
    1392:	3b250513          	addi	a0,a0,946 # 6740 <malloc+0xc60>
    1396:	00004097          	auipc	ra,0x4
    139a:	68c080e7          	jalr	1676(ra) # 5a22 <printf>
    exit(1);
    139e:	4505                	li	a0,1
    13a0:	00004097          	auipc	ra,0x4
    13a4:	30a080e7          	jalr	778(ra) # 56aa <exit>

00000000000013a8 <truncate3>:
{
    13a8:	7159                	addi	sp,sp,-112
    13aa:	f486                	sd	ra,104(sp)
    13ac:	f0a2                	sd	s0,96(sp)
    13ae:	eca6                	sd	s1,88(sp)
    13b0:	e8ca                	sd	s2,80(sp)
    13b2:	e4ce                	sd	s3,72(sp)
    13b4:	e0d2                	sd	s4,64(sp)
    13b6:	fc56                	sd	s5,56(sp)
    13b8:	1880                	addi	s0,sp,112
    13ba:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13bc:	60100593          	li	a1,1537
    13c0:	00005517          	auipc	a0,0x5
    13c4:	bc850513          	addi	a0,a0,-1080 # 5f88 <malloc+0x4a8>
    13c8:	00004097          	auipc	ra,0x4
    13cc:	322080e7          	jalr	802(ra) # 56ea <open>
    13d0:	00004097          	auipc	ra,0x4
    13d4:	302080e7          	jalr	770(ra) # 56d2 <close>
  pid = fork();
    13d8:	00004097          	auipc	ra,0x4
    13dc:	2ca080e7          	jalr	714(ra) # 56a2 <fork>
  if(pid < 0){
    13e0:	08054063          	bltz	a0,1460 <truncate3+0xb8>
  if(pid == 0){
    13e4:	e969                	bnez	a0,14b6 <truncate3+0x10e>
    13e6:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13ea:	00005a17          	auipc	s4,0x5
    13ee:	b9ea0a13          	addi	s4,s4,-1122 # 5f88 <malloc+0x4a8>
      int n = write(fd, "1234567890", 10);
    13f2:	00005a97          	auipc	s5,0x5
    13f6:	3aea8a93          	addi	s5,s5,942 # 67a0 <malloc+0xcc0>
      int fd = open("truncfile", O_WRONLY);
    13fa:	4585                	li	a1,1
    13fc:	8552                	mv	a0,s4
    13fe:	00004097          	auipc	ra,0x4
    1402:	2ec080e7          	jalr	748(ra) # 56ea <open>
    1406:	84aa                	mv	s1,a0
      if(fd < 0){
    1408:	06054a63          	bltz	a0,147c <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    140c:	4629                	li	a2,10
    140e:	85d6                	mv	a1,s5
    1410:	00004097          	auipc	ra,0x4
    1414:	2ba080e7          	jalr	698(ra) # 56ca <write>
      if(n != 10){
    1418:	47a9                	li	a5,10
    141a:	06f51f63          	bne	a0,a5,1498 <truncate3+0xf0>
      close(fd);
    141e:	8526                	mv	a0,s1
    1420:	00004097          	auipc	ra,0x4
    1424:	2b2080e7          	jalr	690(ra) # 56d2 <close>
      fd = open("truncfile", O_RDONLY);
    1428:	4581                	li	a1,0
    142a:	8552                	mv	a0,s4
    142c:	00004097          	auipc	ra,0x4
    1430:	2be080e7          	jalr	702(ra) # 56ea <open>
    1434:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1436:	02000613          	li	a2,32
    143a:	f9840593          	addi	a1,s0,-104
    143e:	00004097          	auipc	ra,0x4
    1442:	284080e7          	jalr	644(ra) # 56c2 <read>
      close(fd);
    1446:	8526                	mv	a0,s1
    1448:	00004097          	auipc	ra,0x4
    144c:	28a080e7          	jalr	650(ra) # 56d2 <close>
    for(int i = 0; i < 100; i++){
    1450:	39fd                	addiw	s3,s3,-1
    1452:	fa0994e3          	bnez	s3,13fa <truncate3+0x52>
    exit(0);
    1456:	4501                	li	a0,0
    1458:	00004097          	auipc	ra,0x4
    145c:	252080e7          	jalr	594(ra) # 56aa <exit>
    printf("%s: fork failed\n", s);
    1460:	85ca                	mv	a1,s2
    1462:	00005517          	auipc	a0,0x5
    1466:	30e50513          	addi	a0,a0,782 # 6770 <malloc+0xc90>
    146a:	00004097          	auipc	ra,0x4
    146e:	5b8080e7          	jalr	1464(ra) # 5a22 <printf>
    exit(1);
    1472:	4505                	li	a0,1
    1474:	00004097          	auipc	ra,0x4
    1478:	236080e7          	jalr	566(ra) # 56aa <exit>
        printf("%s: open failed\n", s);
    147c:	85ca                	mv	a1,s2
    147e:	00005517          	auipc	a0,0x5
    1482:	30a50513          	addi	a0,a0,778 # 6788 <malloc+0xca8>
    1486:	00004097          	auipc	ra,0x4
    148a:	59c080e7          	jalr	1436(ra) # 5a22 <printf>
        exit(1);
    148e:	4505                	li	a0,1
    1490:	00004097          	auipc	ra,0x4
    1494:	21a080e7          	jalr	538(ra) # 56aa <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1498:	862a                	mv	a2,a0
    149a:	85ca                	mv	a1,s2
    149c:	00005517          	auipc	a0,0x5
    14a0:	31450513          	addi	a0,a0,788 # 67b0 <malloc+0xcd0>
    14a4:	00004097          	auipc	ra,0x4
    14a8:	57e080e7          	jalr	1406(ra) # 5a22 <printf>
        exit(1);
    14ac:	4505                	li	a0,1
    14ae:	00004097          	auipc	ra,0x4
    14b2:	1fc080e7          	jalr	508(ra) # 56aa <exit>
    14b6:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14ba:	00005a17          	auipc	s4,0x5
    14be:	acea0a13          	addi	s4,s4,-1330 # 5f88 <malloc+0x4a8>
    int n = write(fd, "xxx", 3);
    14c2:	00005a97          	auipc	s5,0x5
    14c6:	30ea8a93          	addi	s5,s5,782 # 67d0 <malloc+0xcf0>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14ca:	60100593          	li	a1,1537
    14ce:	8552                	mv	a0,s4
    14d0:	00004097          	auipc	ra,0x4
    14d4:	21a080e7          	jalr	538(ra) # 56ea <open>
    14d8:	84aa                	mv	s1,a0
    if(fd < 0){
    14da:	04054763          	bltz	a0,1528 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14de:	460d                	li	a2,3
    14e0:	85d6                	mv	a1,s5
    14e2:	00004097          	auipc	ra,0x4
    14e6:	1e8080e7          	jalr	488(ra) # 56ca <write>
    if(n != 3){
    14ea:	478d                	li	a5,3
    14ec:	04f51c63          	bne	a0,a5,1544 <truncate3+0x19c>
    close(fd);
    14f0:	8526                	mv	a0,s1
    14f2:	00004097          	auipc	ra,0x4
    14f6:	1e0080e7          	jalr	480(ra) # 56d2 <close>
  for(int i = 0; i < 150; i++){
    14fa:	39fd                	addiw	s3,s3,-1
    14fc:	fc0997e3          	bnez	s3,14ca <truncate3+0x122>
  wait(&xstatus);
    1500:	fbc40513          	addi	a0,s0,-68
    1504:	00004097          	auipc	ra,0x4
    1508:	1ae080e7          	jalr	430(ra) # 56b2 <wait>
  unlink("truncfile");
    150c:	00005517          	auipc	a0,0x5
    1510:	a7c50513          	addi	a0,a0,-1412 # 5f88 <malloc+0x4a8>
    1514:	00004097          	auipc	ra,0x4
    1518:	1e6080e7          	jalr	486(ra) # 56fa <unlink>
  exit(xstatus);
    151c:	fbc42503          	lw	a0,-68(s0)
    1520:	00004097          	auipc	ra,0x4
    1524:	18a080e7          	jalr	394(ra) # 56aa <exit>
      printf("%s: open failed\n", s);
    1528:	85ca                	mv	a1,s2
    152a:	00005517          	auipc	a0,0x5
    152e:	25e50513          	addi	a0,a0,606 # 6788 <malloc+0xca8>
    1532:	00004097          	auipc	ra,0x4
    1536:	4f0080e7          	jalr	1264(ra) # 5a22 <printf>
      exit(1);
    153a:	4505                	li	a0,1
    153c:	00004097          	auipc	ra,0x4
    1540:	16e080e7          	jalr	366(ra) # 56aa <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1544:	862a                	mv	a2,a0
    1546:	85ca                	mv	a1,s2
    1548:	00005517          	auipc	a0,0x5
    154c:	29050513          	addi	a0,a0,656 # 67d8 <malloc+0xcf8>
    1550:	00004097          	auipc	ra,0x4
    1554:	4d2080e7          	jalr	1234(ra) # 5a22 <printf>
      exit(1);
    1558:	4505                	li	a0,1
    155a:	00004097          	auipc	ra,0x4
    155e:	150080e7          	jalr	336(ra) # 56aa <exit>

0000000000001562 <exectest>:
{
    1562:	715d                	addi	sp,sp,-80
    1564:	e486                	sd	ra,72(sp)
    1566:	e0a2                	sd	s0,64(sp)
    1568:	fc26                	sd	s1,56(sp)
    156a:	f84a                	sd	s2,48(sp)
    156c:	0880                	addi	s0,sp,80
    156e:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1570:	00005797          	auipc	a5,0x5
    1574:	9c078793          	addi	a5,a5,-1600 # 5f30 <malloc+0x450>
    1578:	fcf43023          	sd	a5,-64(s0)
    157c:	00005797          	auipc	a5,0x5
    1580:	27c78793          	addi	a5,a5,636 # 67f8 <malloc+0xd18>
    1584:	fcf43423          	sd	a5,-56(s0)
    1588:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    158c:	00005517          	auipc	a0,0x5
    1590:	27450513          	addi	a0,a0,628 # 6800 <malloc+0xd20>
    1594:	00004097          	auipc	ra,0x4
    1598:	166080e7          	jalr	358(ra) # 56fa <unlink>
  pid = fork();
    159c:	00004097          	auipc	ra,0x4
    15a0:	106080e7          	jalr	262(ra) # 56a2 <fork>
  if(pid < 0) {
    15a4:	04054663          	bltz	a0,15f0 <exectest+0x8e>
    15a8:	84aa                	mv	s1,a0
  if(pid == 0) {
    15aa:	e959                	bnez	a0,1640 <exectest+0xde>
    close(1);
    15ac:	4505                	li	a0,1
    15ae:	00004097          	auipc	ra,0x4
    15b2:	124080e7          	jalr	292(ra) # 56d2 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15b6:	20100593          	li	a1,513
    15ba:	00005517          	auipc	a0,0x5
    15be:	24650513          	addi	a0,a0,582 # 6800 <malloc+0xd20>
    15c2:	00004097          	auipc	ra,0x4
    15c6:	128080e7          	jalr	296(ra) # 56ea <open>
    if(fd < 0) {
    15ca:	04054163          	bltz	a0,160c <exectest+0xaa>
    if(fd != 1) {
    15ce:	4785                	li	a5,1
    15d0:	04f50c63          	beq	a0,a5,1628 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15d4:	85ca                	mv	a1,s2
    15d6:	00005517          	auipc	a0,0x5
    15da:	24a50513          	addi	a0,a0,586 # 6820 <malloc+0xd40>
    15de:	00004097          	auipc	ra,0x4
    15e2:	444080e7          	jalr	1092(ra) # 5a22 <printf>
      exit(1);
    15e6:	4505                	li	a0,1
    15e8:	00004097          	auipc	ra,0x4
    15ec:	0c2080e7          	jalr	194(ra) # 56aa <exit>
     printf("%s: fork failed\n", s);
    15f0:	85ca                	mv	a1,s2
    15f2:	00005517          	auipc	a0,0x5
    15f6:	17e50513          	addi	a0,a0,382 # 6770 <malloc+0xc90>
    15fa:	00004097          	auipc	ra,0x4
    15fe:	428080e7          	jalr	1064(ra) # 5a22 <printf>
     exit(1);
    1602:	4505                	li	a0,1
    1604:	00004097          	auipc	ra,0x4
    1608:	0a6080e7          	jalr	166(ra) # 56aa <exit>
      printf("%s: create failed\n", s);
    160c:	85ca                	mv	a1,s2
    160e:	00005517          	auipc	a0,0x5
    1612:	1fa50513          	addi	a0,a0,506 # 6808 <malloc+0xd28>
    1616:	00004097          	auipc	ra,0x4
    161a:	40c080e7          	jalr	1036(ra) # 5a22 <printf>
      exit(1);
    161e:	4505                	li	a0,1
    1620:	00004097          	auipc	ra,0x4
    1624:	08a080e7          	jalr	138(ra) # 56aa <exit>
    if(exec("echo", echoargv) < 0){
    1628:	fc040593          	addi	a1,s0,-64
    162c:	00005517          	auipc	a0,0x5
    1630:	90450513          	addi	a0,a0,-1788 # 5f30 <malloc+0x450>
    1634:	00004097          	auipc	ra,0x4
    1638:	0ae080e7          	jalr	174(ra) # 56e2 <exec>
    163c:	02054163          	bltz	a0,165e <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1640:	fdc40513          	addi	a0,s0,-36
    1644:	00004097          	auipc	ra,0x4
    1648:	06e080e7          	jalr	110(ra) # 56b2 <wait>
    164c:	02951763          	bne	a0,s1,167a <exectest+0x118>
  if(xstatus != 0)
    1650:	fdc42503          	lw	a0,-36(s0)
    1654:	cd0d                	beqz	a0,168e <exectest+0x12c>
    exit(xstatus);
    1656:	00004097          	auipc	ra,0x4
    165a:	054080e7          	jalr	84(ra) # 56aa <exit>
      printf("%s: exec echo failed\n", s);
    165e:	85ca                	mv	a1,s2
    1660:	00005517          	auipc	a0,0x5
    1664:	1d050513          	addi	a0,a0,464 # 6830 <malloc+0xd50>
    1668:	00004097          	auipc	ra,0x4
    166c:	3ba080e7          	jalr	954(ra) # 5a22 <printf>
      exit(1);
    1670:	4505                	li	a0,1
    1672:	00004097          	auipc	ra,0x4
    1676:	038080e7          	jalr	56(ra) # 56aa <exit>
    printf("%s: wait failed!\n", s);
    167a:	85ca                	mv	a1,s2
    167c:	00005517          	auipc	a0,0x5
    1680:	1cc50513          	addi	a0,a0,460 # 6848 <malloc+0xd68>
    1684:	00004097          	auipc	ra,0x4
    1688:	39e080e7          	jalr	926(ra) # 5a22 <printf>
    168c:	b7d1                	j	1650 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    168e:	4581                	li	a1,0
    1690:	00005517          	auipc	a0,0x5
    1694:	17050513          	addi	a0,a0,368 # 6800 <malloc+0xd20>
    1698:	00004097          	auipc	ra,0x4
    169c:	052080e7          	jalr	82(ra) # 56ea <open>
  if(fd < 0) {
    16a0:	02054a63          	bltz	a0,16d4 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16a4:	4609                	li	a2,2
    16a6:	fb840593          	addi	a1,s0,-72
    16aa:	00004097          	auipc	ra,0x4
    16ae:	018080e7          	jalr	24(ra) # 56c2 <read>
    16b2:	4789                	li	a5,2
    16b4:	02f50e63          	beq	a0,a5,16f0 <exectest+0x18e>
    printf("%s: read failed\n", s);
    16b8:	85ca                	mv	a1,s2
    16ba:	00005517          	auipc	a0,0x5
    16be:	c0e50513          	addi	a0,a0,-1010 # 62c8 <malloc+0x7e8>
    16c2:	00004097          	auipc	ra,0x4
    16c6:	360080e7          	jalr	864(ra) # 5a22 <printf>
    exit(1);
    16ca:	4505                	li	a0,1
    16cc:	00004097          	auipc	ra,0x4
    16d0:	fde080e7          	jalr	-34(ra) # 56aa <exit>
    printf("%s: open failed\n", s);
    16d4:	85ca                	mv	a1,s2
    16d6:	00005517          	auipc	a0,0x5
    16da:	0b250513          	addi	a0,a0,178 # 6788 <malloc+0xca8>
    16de:	00004097          	auipc	ra,0x4
    16e2:	344080e7          	jalr	836(ra) # 5a22 <printf>
    exit(1);
    16e6:	4505                	li	a0,1
    16e8:	00004097          	auipc	ra,0x4
    16ec:	fc2080e7          	jalr	-62(ra) # 56aa <exit>
  unlink("echo-ok");
    16f0:	00005517          	auipc	a0,0x5
    16f4:	11050513          	addi	a0,a0,272 # 6800 <malloc+0xd20>
    16f8:	00004097          	auipc	ra,0x4
    16fc:	002080e7          	jalr	2(ra) # 56fa <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1700:	fb844703          	lbu	a4,-72(s0)
    1704:	04f00793          	li	a5,79
    1708:	00f71863          	bne	a4,a5,1718 <exectest+0x1b6>
    170c:	fb944703          	lbu	a4,-71(s0)
    1710:	04b00793          	li	a5,75
    1714:	02f70063          	beq	a4,a5,1734 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1718:	85ca                	mv	a1,s2
    171a:	00005517          	auipc	a0,0x5
    171e:	14650513          	addi	a0,a0,326 # 6860 <malloc+0xd80>
    1722:	00004097          	auipc	ra,0x4
    1726:	300080e7          	jalr	768(ra) # 5a22 <printf>
    exit(1);
    172a:	4505                	li	a0,1
    172c:	00004097          	auipc	ra,0x4
    1730:	f7e080e7          	jalr	-130(ra) # 56aa <exit>
    exit(0);
    1734:	4501                	li	a0,0
    1736:	00004097          	auipc	ra,0x4
    173a:	f74080e7          	jalr	-140(ra) # 56aa <exit>

000000000000173e <pipe1>:
{
    173e:	711d                	addi	sp,sp,-96
    1740:	ec86                	sd	ra,88(sp)
    1742:	e8a2                	sd	s0,80(sp)
    1744:	e4a6                	sd	s1,72(sp)
    1746:	e0ca                	sd	s2,64(sp)
    1748:	fc4e                	sd	s3,56(sp)
    174a:	f852                	sd	s4,48(sp)
    174c:	f456                	sd	s5,40(sp)
    174e:	f05a                	sd	s6,32(sp)
    1750:	ec5e                	sd	s7,24(sp)
    1752:	1080                	addi	s0,sp,96
    1754:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1756:	fa840513          	addi	a0,s0,-88
    175a:	00004097          	auipc	ra,0x4
    175e:	f60080e7          	jalr	-160(ra) # 56ba <pipe>
    1762:	ed25                	bnez	a0,17da <pipe1+0x9c>
    1764:	84aa                	mv	s1,a0
  pid = fork();
    1766:	00004097          	auipc	ra,0x4
    176a:	f3c080e7          	jalr	-196(ra) # 56a2 <fork>
    176e:	8a2a                	mv	s4,a0
  if(pid == 0){
    1770:	c159                	beqz	a0,17f6 <pipe1+0xb8>
  } else if(pid > 0){
    1772:	16a05e63          	blez	a0,18ee <pipe1+0x1b0>
    close(fds[1]);
    1776:	fac42503          	lw	a0,-84(s0)
    177a:	00004097          	auipc	ra,0x4
    177e:	f58080e7          	jalr	-168(ra) # 56d2 <close>
    total = 0;
    1782:	8a26                	mv	s4,s1
    cc = 1;
    1784:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1786:	0000aa97          	auipc	s5,0xa
    178a:	3faa8a93          	addi	s5,s5,1018 # bb80 <buf>
      if(cc > sizeof(buf))
    178e:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1790:	864e                	mv	a2,s3
    1792:	85d6                	mv	a1,s5
    1794:	fa842503          	lw	a0,-88(s0)
    1798:	00004097          	auipc	ra,0x4
    179c:	f2a080e7          	jalr	-214(ra) # 56c2 <read>
    17a0:	10a05263          	blez	a0,18a4 <pipe1+0x166>
      for(i = 0; i < n; i++){
    17a4:	0000a717          	auipc	a4,0xa
    17a8:	3dc70713          	addi	a4,a4,988 # bb80 <buf>
    17ac:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17b0:	00074683          	lbu	a3,0(a4)
    17b4:	0ff4f793          	andi	a5,s1,255
    17b8:	2485                	addiw	s1,s1,1
    17ba:	0cf69163          	bne	a3,a5,187c <pipe1+0x13e>
      for(i = 0; i < n; i++){
    17be:	0705                	addi	a4,a4,1
    17c0:	fec498e3          	bne	s1,a2,17b0 <pipe1+0x72>
      total += n;
    17c4:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17c8:	0019979b          	slliw	a5,s3,0x1
    17cc:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17d0:	013b7363          	bgeu	s6,s3,17d6 <pipe1+0x98>
        cc = sizeof(buf);
    17d4:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17d6:	84b2                	mv	s1,a2
    17d8:	bf65                	j	1790 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    17da:	85ca                	mv	a1,s2
    17dc:	00005517          	auipc	a0,0x5
    17e0:	09c50513          	addi	a0,a0,156 # 6878 <malloc+0xd98>
    17e4:	00004097          	auipc	ra,0x4
    17e8:	23e080e7          	jalr	574(ra) # 5a22 <printf>
    exit(1);
    17ec:	4505                	li	a0,1
    17ee:	00004097          	auipc	ra,0x4
    17f2:	ebc080e7          	jalr	-324(ra) # 56aa <exit>
    close(fds[0]);
    17f6:	fa842503          	lw	a0,-88(s0)
    17fa:	00004097          	auipc	ra,0x4
    17fe:	ed8080e7          	jalr	-296(ra) # 56d2 <close>
    for(n = 0; n < N; n++){
    1802:	0000ab17          	auipc	s6,0xa
    1806:	37eb0b13          	addi	s6,s6,894 # bb80 <buf>
    180a:	416004bb          	negw	s1,s6
    180e:	0ff4f493          	andi	s1,s1,255
    1812:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1816:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1818:	6a85                	lui	s5,0x1
    181a:	42da8a93          	addi	s5,s5,1069 # 142d <truncate3+0x85>
{
    181e:	87da                	mv	a5,s6
        buf[i] = seq++;
    1820:	0097873b          	addw	a4,a5,s1
    1824:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1828:	0785                	addi	a5,a5,1
    182a:	fef99be3          	bne	s3,a5,1820 <pipe1+0xe2>
    182e:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1832:	40900613          	li	a2,1033
    1836:	85de                	mv	a1,s7
    1838:	fac42503          	lw	a0,-84(s0)
    183c:	00004097          	auipc	ra,0x4
    1840:	e8e080e7          	jalr	-370(ra) # 56ca <write>
    1844:	40900793          	li	a5,1033
    1848:	00f51c63          	bne	a0,a5,1860 <pipe1+0x122>
    for(n = 0; n < N; n++){
    184c:	24a5                	addiw	s1,s1,9
    184e:	0ff4f493          	andi	s1,s1,255
    1852:	fd5a16e3          	bne	s4,s5,181e <pipe1+0xe0>
    exit(0);
    1856:	4501                	li	a0,0
    1858:	00004097          	auipc	ra,0x4
    185c:	e52080e7          	jalr	-430(ra) # 56aa <exit>
        printf("%s: pipe1 oops 1\n", s);
    1860:	85ca                	mv	a1,s2
    1862:	00005517          	auipc	a0,0x5
    1866:	02e50513          	addi	a0,a0,46 # 6890 <malloc+0xdb0>
    186a:	00004097          	auipc	ra,0x4
    186e:	1b8080e7          	jalr	440(ra) # 5a22 <printf>
        exit(1);
    1872:	4505                	li	a0,1
    1874:	00004097          	auipc	ra,0x4
    1878:	e36080e7          	jalr	-458(ra) # 56aa <exit>
          printf("%s: pipe1 oops 2\n", s);
    187c:	85ca                	mv	a1,s2
    187e:	00005517          	auipc	a0,0x5
    1882:	02a50513          	addi	a0,a0,42 # 68a8 <malloc+0xdc8>
    1886:	00004097          	auipc	ra,0x4
    188a:	19c080e7          	jalr	412(ra) # 5a22 <printf>
}
    188e:	60e6                	ld	ra,88(sp)
    1890:	6446                	ld	s0,80(sp)
    1892:	64a6                	ld	s1,72(sp)
    1894:	6906                	ld	s2,64(sp)
    1896:	79e2                	ld	s3,56(sp)
    1898:	7a42                	ld	s4,48(sp)
    189a:	7aa2                	ld	s5,40(sp)
    189c:	7b02                	ld	s6,32(sp)
    189e:	6be2                	ld	s7,24(sp)
    18a0:	6125                	addi	sp,sp,96
    18a2:	8082                	ret
    if(total != N * SZ){
    18a4:	6785                	lui	a5,0x1
    18a6:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x85>
    18aa:	02fa0063          	beq	s4,a5,18ca <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18ae:	85d2                	mv	a1,s4
    18b0:	00005517          	auipc	a0,0x5
    18b4:	01050513          	addi	a0,a0,16 # 68c0 <malloc+0xde0>
    18b8:	00004097          	auipc	ra,0x4
    18bc:	16a080e7          	jalr	362(ra) # 5a22 <printf>
      exit(1);
    18c0:	4505                	li	a0,1
    18c2:	00004097          	auipc	ra,0x4
    18c6:	de8080e7          	jalr	-536(ra) # 56aa <exit>
    close(fds[0]);
    18ca:	fa842503          	lw	a0,-88(s0)
    18ce:	00004097          	auipc	ra,0x4
    18d2:	e04080e7          	jalr	-508(ra) # 56d2 <close>
    wait(&xstatus);
    18d6:	fa440513          	addi	a0,s0,-92
    18da:	00004097          	auipc	ra,0x4
    18de:	dd8080e7          	jalr	-552(ra) # 56b2 <wait>
    exit(xstatus);
    18e2:	fa442503          	lw	a0,-92(s0)
    18e6:	00004097          	auipc	ra,0x4
    18ea:	dc4080e7          	jalr	-572(ra) # 56aa <exit>
    printf("%s: fork() failed\n", s);
    18ee:	85ca                	mv	a1,s2
    18f0:	00005517          	auipc	a0,0x5
    18f4:	ff050513          	addi	a0,a0,-16 # 68e0 <malloc+0xe00>
    18f8:	00004097          	auipc	ra,0x4
    18fc:	12a080e7          	jalr	298(ra) # 5a22 <printf>
    exit(1);
    1900:	4505                	li	a0,1
    1902:	00004097          	auipc	ra,0x4
    1906:	da8080e7          	jalr	-600(ra) # 56aa <exit>

000000000000190a <exitwait>:
{
    190a:	7139                	addi	sp,sp,-64
    190c:	fc06                	sd	ra,56(sp)
    190e:	f822                	sd	s0,48(sp)
    1910:	f426                	sd	s1,40(sp)
    1912:	f04a                	sd	s2,32(sp)
    1914:	ec4e                	sd	s3,24(sp)
    1916:	e852                	sd	s4,16(sp)
    1918:	0080                	addi	s0,sp,64
    191a:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    191c:	4901                	li	s2,0
    191e:	06400993          	li	s3,100
    pid = fork();
    1922:	00004097          	auipc	ra,0x4
    1926:	d80080e7          	jalr	-640(ra) # 56a2 <fork>
    192a:	84aa                	mv	s1,a0
    if(pid < 0){
    192c:	02054a63          	bltz	a0,1960 <exitwait+0x56>
    if(pid){
    1930:	c151                	beqz	a0,19b4 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1932:	fcc40513          	addi	a0,s0,-52
    1936:	00004097          	auipc	ra,0x4
    193a:	d7c080e7          	jalr	-644(ra) # 56b2 <wait>
    193e:	02951f63          	bne	a0,s1,197c <exitwait+0x72>
      if(i != xstate) {
    1942:	fcc42783          	lw	a5,-52(s0)
    1946:	05279963          	bne	a5,s2,1998 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    194a:	2905                	addiw	s2,s2,1
    194c:	fd391be3          	bne	s2,s3,1922 <exitwait+0x18>
}
    1950:	70e2                	ld	ra,56(sp)
    1952:	7442                	ld	s0,48(sp)
    1954:	74a2                	ld	s1,40(sp)
    1956:	7902                	ld	s2,32(sp)
    1958:	69e2                	ld	s3,24(sp)
    195a:	6a42                	ld	s4,16(sp)
    195c:	6121                	addi	sp,sp,64
    195e:	8082                	ret
      printf("%s: fork failed\n", s);
    1960:	85d2                	mv	a1,s4
    1962:	00005517          	auipc	a0,0x5
    1966:	e0e50513          	addi	a0,a0,-498 # 6770 <malloc+0xc90>
    196a:	00004097          	auipc	ra,0x4
    196e:	0b8080e7          	jalr	184(ra) # 5a22 <printf>
      exit(1);
    1972:	4505                	li	a0,1
    1974:	00004097          	auipc	ra,0x4
    1978:	d36080e7          	jalr	-714(ra) # 56aa <exit>
        printf("%s: wait wrong pid\n", s);
    197c:	85d2                	mv	a1,s4
    197e:	00005517          	auipc	a0,0x5
    1982:	f7a50513          	addi	a0,a0,-134 # 68f8 <malloc+0xe18>
    1986:	00004097          	auipc	ra,0x4
    198a:	09c080e7          	jalr	156(ra) # 5a22 <printf>
        exit(1);
    198e:	4505                	li	a0,1
    1990:	00004097          	auipc	ra,0x4
    1994:	d1a080e7          	jalr	-742(ra) # 56aa <exit>
        printf("%s: wait wrong exit status\n", s);
    1998:	85d2                	mv	a1,s4
    199a:	00005517          	auipc	a0,0x5
    199e:	f7650513          	addi	a0,a0,-138 # 6910 <malloc+0xe30>
    19a2:	00004097          	auipc	ra,0x4
    19a6:	080080e7          	jalr	128(ra) # 5a22 <printf>
        exit(1);
    19aa:	4505                	li	a0,1
    19ac:	00004097          	auipc	ra,0x4
    19b0:	cfe080e7          	jalr	-770(ra) # 56aa <exit>
      exit(i);
    19b4:	854a                	mv	a0,s2
    19b6:	00004097          	auipc	ra,0x4
    19ba:	cf4080e7          	jalr	-780(ra) # 56aa <exit>

00000000000019be <twochildren>:
{
    19be:	1101                	addi	sp,sp,-32
    19c0:	ec06                	sd	ra,24(sp)
    19c2:	e822                	sd	s0,16(sp)
    19c4:	e426                	sd	s1,8(sp)
    19c6:	e04a                	sd	s2,0(sp)
    19c8:	1000                	addi	s0,sp,32
    19ca:	892a                	mv	s2,a0
    19cc:	3e800493          	li	s1,1000
    int pid1 = fork();
    19d0:	00004097          	auipc	ra,0x4
    19d4:	cd2080e7          	jalr	-814(ra) # 56a2 <fork>
    if(pid1 < 0){
    19d8:	02054c63          	bltz	a0,1a10 <twochildren+0x52>
    if(pid1 == 0){
    19dc:	c921                	beqz	a0,1a2c <twochildren+0x6e>
      int pid2 = fork();
    19de:	00004097          	auipc	ra,0x4
    19e2:	cc4080e7          	jalr	-828(ra) # 56a2 <fork>
      if(pid2 < 0){
    19e6:	04054763          	bltz	a0,1a34 <twochildren+0x76>
      if(pid2 == 0){
    19ea:	c13d                	beqz	a0,1a50 <twochildren+0x92>
        wait(0);
    19ec:	4501                	li	a0,0
    19ee:	00004097          	auipc	ra,0x4
    19f2:	cc4080e7          	jalr	-828(ra) # 56b2 <wait>
        wait(0);
    19f6:	4501                	li	a0,0
    19f8:	00004097          	auipc	ra,0x4
    19fc:	cba080e7          	jalr	-838(ra) # 56b2 <wait>
  for(int i = 0; i < 1000; i++){
    1a00:	34fd                	addiw	s1,s1,-1
    1a02:	f4f9                	bnez	s1,19d0 <twochildren+0x12>
}
    1a04:	60e2                	ld	ra,24(sp)
    1a06:	6442                	ld	s0,16(sp)
    1a08:	64a2                	ld	s1,8(sp)
    1a0a:	6902                	ld	s2,0(sp)
    1a0c:	6105                	addi	sp,sp,32
    1a0e:	8082                	ret
      printf("%s: fork failed\n", s);
    1a10:	85ca                	mv	a1,s2
    1a12:	00005517          	auipc	a0,0x5
    1a16:	d5e50513          	addi	a0,a0,-674 # 6770 <malloc+0xc90>
    1a1a:	00004097          	auipc	ra,0x4
    1a1e:	008080e7          	jalr	8(ra) # 5a22 <printf>
      exit(1);
    1a22:	4505                	li	a0,1
    1a24:	00004097          	auipc	ra,0x4
    1a28:	c86080e7          	jalr	-890(ra) # 56aa <exit>
      exit(0);
    1a2c:	00004097          	auipc	ra,0x4
    1a30:	c7e080e7          	jalr	-898(ra) # 56aa <exit>
        printf("%s: fork failed\n", s);
    1a34:	85ca                	mv	a1,s2
    1a36:	00005517          	auipc	a0,0x5
    1a3a:	d3a50513          	addi	a0,a0,-710 # 6770 <malloc+0xc90>
    1a3e:	00004097          	auipc	ra,0x4
    1a42:	fe4080e7          	jalr	-28(ra) # 5a22 <printf>
        exit(1);
    1a46:	4505                	li	a0,1
    1a48:	00004097          	auipc	ra,0x4
    1a4c:	c62080e7          	jalr	-926(ra) # 56aa <exit>
        exit(0);
    1a50:	00004097          	auipc	ra,0x4
    1a54:	c5a080e7          	jalr	-934(ra) # 56aa <exit>

0000000000001a58 <forkfork>:
{
    1a58:	7179                	addi	sp,sp,-48
    1a5a:	f406                	sd	ra,40(sp)
    1a5c:	f022                	sd	s0,32(sp)
    1a5e:	ec26                	sd	s1,24(sp)
    1a60:	1800                	addi	s0,sp,48
    1a62:	84aa                	mv	s1,a0
    int pid = fork();
    1a64:	00004097          	auipc	ra,0x4
    1a68:	c3e080e7          	jalr	-962(ra) # 56a2 <fork>
    if(pid < 0){
    1a6c:	04054163          	bltz	a0,1aae <forkfork+0x56>
    if(pid == 0){
    1a70:	cd29                	beqz	a0,1aca <forkfork+0x72>
    int pid = fork();
    1a72:	00004097          	auipc	ra,0x4
    1a76:	c30080e7          	jalr	-976(ra) # 56a2 <fork>
    if(pid < 0){
    1a7a:	02054a63          	bltz	a0,1aae <forkfork+0x56>
    if(pid == 0){
    1a7e:	c531                	beqz	a0,1aca <forkfork+0x72>
    wait(&xstatus);
    1a80:	fdc40513          	addi	a0,s0,-36
    1a84:	00004097          	auipc	ra,0x4
    1a88:	c2e080e7          	jalr	-978(ra) # 56b2 <wait>
    if(xstatus != 0) {
    1a8c:	fdc42783          	lw	a5,-36(s0)
    1a90:	ebbd                	bnez	a5,1b06 <forkfork+0xae>
    wait(&xstatus);
    1a92:	fdc40513          	addi	a0,s0,-36
    1a96:	00004097          	auipc	ra,0x4
    1a9a:	c1c080e7          	jalr	-996(ra) # 56b2 <wait>
    if(xstatus != 0) {
    1a9e:	fdc42783          	lw	a5,-36(s0)
    1aa2:	e3b5                	bnez	a5,1b06 <forkfork+0xae>
}
    1aa4:	70a2                	ld	ra,40(sp)
    1aa6:	7402                	ld	s0,32(sp)
    1aa8:	64e2                	ld	s1,24(sp)
    1aaa:	6145                	addi	sp,sp,48
    1aac:	8082                	ret
      printf("%s: fork failed", s);
    1aae:	85a6                	mv	a1,s1
    1ab0:	00005517          	auipc	a0,0x5
    1ab4:	e8050513          	addi	a0,a0,-384 # 6930 <malloc+0xe50>
    1ab8:	00004097          	auipc	ra,0x4
    1abc:	f6a080e7          	jalr	-150(ra) # 5a22 <printf>
      exit(1);
    1ac0:	4505                	li	a0,1
    1ac2:	00004097          	auipc	ra,0x4
    1ac6:	be8080e7          	jalr	-1048(ra) # 56aa <exit>
{
    1aca:	0c800493          	li	s1,200
        int pid1 = fork();
    1ace:	00004097          	auipc	ra,0x4
    1ad2:	bd4080e7          	jalr	-1068(ra) # 56a2 <fork>
        if(pid1 < 0){
    1ad6:	00054f63          	bltz	a0,1af4 <forkfork+0x9c>
        if(pid1 == 0){
    1ada:	c115                	beqz	a0,1afe <forkfork+0xa6>
        wait(0);
    1adc:	4501                	li	a0,0
    1ade:	00004097          	auipc	ra,0x4
    1ae2:	bd4080e7          	jalr	-1068(ra) # 56b2 <wait>
      for(int j = 0; j < 200; j++){
    1ae6:	34fd                	addiw	s1,s1,-1
    1ae8:	f0fd                	bnez	s1,1ace <forkfork+0x76>
      exit(0);
    1aea:	4501                	li	a0,0
    1aec:	00004097          	auipc	ra,0x4
    1af0:	bbe080e7          	jalr	-1090(ra) # 56aa <exit>
          exit(1);
    1af4:	4505                	li	a0,1
    1af6:	00004097          	auipc	ra,0x4
    1afa:	bb4080e7          	jalr	-1100(ra) # 56aa <exit>
          exit(0);
    1afe:	00004097          	auipc	ra,0x4
    1b02:	bac080e7          	jalr	-1108(ra) # 56aa <exit>
      printf("%s: fork in child failed", s);
    1b06:	85a6                	mv	a1,s1
    1b08:	00005517          	auipc	a0,0x5
    1b0c:	e3850513          	addi	a0,a0,-456 # 6940 <malloc+0xe60>
    1b10:	00004097          	auipc	ra,0x4
    1b14:	f12080e7          	jalr	-238(ra) # 5a22 <printf>
      exit(1);
    1b18:	4505                	li	a0,1
    1b1a:	00004097          	auipc	ra,0x4
    1b1e:	b90080e7          	jalr	-1136(ra) # 56aa <exit>

0000000000001b22 <reparent2>:
{
    1b22:	1101                	addi	sp,sp,-32
    1b24:	ec06                	sd	ra,24(sp)
    1b26:	e822                	sd	s0,16(sp)
    1b28:	e426                	sd	s1,8(sp)
    1b2a:	1000                	addi	s0,sp,32
    1b2c:	32000493          	li	s1,800
    int pid1 = fork();
    1b30:	00004097          	auipc	ra,0x4
    1b34:	b72080e7          	jalr	-1166(ra) # 56a2 <fork>
    if(pid1 < 0){
    1b38:	00054f63          	bltz	a0,1b56 <reparent2+0x34>
    if(pid1 == 0){
    1b3c:	c915                	beqz	a0,1b70 <reparent2+0x4e>
    wait(0);
    1b3e:	4501                	li	a0,0
    1b40:	00004097          	auipc	ra,0x4
    1b44:	b72080e7          	jalr	-1166(ra) # 56b2 <wait>
  for(int i = 0; i < 800; i++){
    1b48:	34fd                	addiw	s1,s1,-1
    1b4a:	f0fd                	bnez	s1,1b30 <reparent2+0xe>
  exit(0);
    1b4c:	4501                	li	a0,0
    1b4e:	00004097          	auipc	ra,0x4
    1b52:	b5c080e7          	jalr	-1188(ra) # 56aa <exit>
      printf("fork failed\n");
    1b56:	00005517          	auipc	a0,0x5
    1b5a:	02250513          	addi	a0,a0,34 # 6b78 <malloc+0x1098>
    1b5e:	00004097          	auipc	ra,0x4
    1b62:	ec4080e7          	jalr	-316(ra) # 5a22 <printf>
      exit(1);
    1b66:	4505                	li	a0,1
    1b68:	00004097          	auipc	ra,0x4
    1b6c:	b42080e7          	jalr	-1214(ra) # 56aa <exit>
      fork();
    1b70:	00004097          	auipc	ra,0x4
    1b74:	b32080e7          	jalr	-1230(ra) # 56a2 <fork>
      fork();
    1b78:	00004097          	auipc	ra,0x4
    1b7c:	b2a080e7          	jalr	-1238(ra) # 56a2 <fork>
      exit(0);
    1b80:	4501                	li	a0,0
    1b82:	00004097          	auipc	ra,0x4
    1b86:	b28080e7          	jalr	-1240(ra) # 56aa <exit>

0000000000001b8a <createdelete>:
{
    1b8a:	7175                	addi	sp,sp,-144
    1b8c:	e506                	sd	ra,136(sp)
    1b8e:	e122                	sd	s0,128(sp)
    1b90:	fca6                	sd	s1,120(sp)
    1b92:	f8ca                	sd	s2,112(sp)
    1b94:	f4ce                	sd	s3,104(sp)
    1b96:	f0d2                	sd	s4,96(sp)
    1b98:	ecd6                	sd	s5,88(sp)
    1b9a:	e8da                	sd	s6,80(sp)
    1b9c:	e4de                	sd	s7,72(sp)
    1b9e:	e0e2                	sd	s8,64(sp)
    1ba0:	fc66                	sd	s9,56(sp)
    1ba2:	0900                	addi	s0,sp,144
    1ba4:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1ba6:	4901                	li	s2,0
    1ba8:	4991                	li	s3,4
    pid = fork();
    1baa:	00004097          	auipc	ra,0x4
    1bae:	af8080e7          	jalr	-1288(ra) # 56a2 <fork>
    1bb2:	84aa                	mv	s1,a0
    if(pid < 0){
    1bb4:	02054f63          	bltz	a0,1bf2 <createdelete+0x68>
    if(pid == 0){
    1bb8:	c939                	beqz	a0,1c0e <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bba:	2905                	addiw	s2,s2,1
    1bbc:	ff3917e3          	bne	s2,s3,1baa <createdelete+0x20>
    1bc0:	4491                	li	s1,4
    wait(&xstatus);
    1bc2:	f7c40513          	addi	a0,s0,-132
    1bc6:	00004097          	auipc	ra,0x4
    1bca:	aec080e7          	jalr	-1300(ra) # 56b2 <wait>
    if(xstatus != 0)
    1bce:	f7c42903          	lw	s2,-132(s0)
    1bd2:	0e091263          	bnez	s2,1cb6 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1bd6:	34fd                	addiw	s1,s1,-1
    1bd8:	f4ed                	bnez	s1,1bc2 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1bda:	f8040123          	sb	zero,-126(s0)
    1bde:	03000993          	li	s3,48
    1be2:	5a7d                	li	s4,-1
    1be4:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1be8:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1bea:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1bec:	07400a93          	li	s5,116
    1bf0:	a29d                	j	1d56 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1bf2:	85e6                	mv	a1,s9
    1bf4:	00005517          	auipc	a0,0x5
    1bf8:	f8450513          	addi	a0,a0,-124 # 6b78 <malloc+0x1098>
    1bfc:	00004097          	auipc	ra,0x4
    1c00:	e26080e7          	jalr	-474(ra) # 5a22 <printf>
      exit(1);
    1c04:	4505                	li	a0,1
    1c06:	00004097          	auipc	ra,0x4
    1c0a:	aa4080e7          	jalr	-1372(ra) # 56aa <exit>
      name[0] = 'p' + pi;
    1c0e:	0709091b          	addiw	s2,s2,112
    1c12:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c16:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c1a:	4951                	li	s2,20
    1c1c:	a015                	j	1c40 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c1e:	85e6                	mv	a1,s9
    1c20:	00005517          	auipc	a0,0x5
    1c24:	be850513          	addi	a0,a0,-1048 # 6808 <malloc+0xd28>
    1c28:	00004097          	auipc	ra,0x4
    1c2c:	dfa080e7          	jalr	-518(ra) # 5a22 <printf>
          exit(1);
    1c30:	4505                	li	a0,1
    1c32:	00004097          	auipc	ra,0x4
    1c36:	a78080e7          	jalr	-1416(ra) # 56aa <exit>
      for(i = 0; i < N; i++){
    1c3a:	2485                	addiw	s1,s1,1
    1c3c:	07248863          	beq	s1,s2,1cac <createdelete+0x122>
        name[1] = '0' + i;
    1c40:	0304879b          	addiw	a5,s1,48
    1c44:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c48:	20200593          	li	a1,514
    1c4c:	f8040513          	addi	a0,s0,-128
    1c50:	00004097          	auipc	ra,0x4
    1c54:	a9a080e7          	jalr	-1382(ra) # 56ea <open>
        if(fd < 0){
    1c58:	fc0543e3          	bltz	a0,1c1e <createdelete+0x94>
        close(fd);
    1c5c:	00004097          	auipc	ra,0x4
    1c60:	a76080e7          	jalr	-1418(ra) # 56d2 <close>
        if(i > 0 && (i % 2 ) == 0){
    1c64:	fc905be3          	blez	s1,1c3a <createdelete+0xb0>
    1c68:	0014f793          	andi	a5,s1,1
    1c6c:	f7f9                	bnez	a5,1c3a <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c6e:	01f4d79b          	srliw	a5,s1,0x1f
    1c72:	9fa5                	addw	a5,a5,s1
    1c74:	4017d79b          	sraiw	a5,a5,0x1
    1c78:	0307879b          	addiw	a5,a5,48
    1c7c:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1c80:	f8040513          	addi	a0,s0,-128
    1c84:	00004097          	auipc	ra,0x4
    1c88:	a76080e7          	jalr	-1418(ra) # 56fa <unlink>
    1c8c:	fa0557e3          	bgez	a0,1c3a <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1c90:	85e6                	mv	a1,s9
    1c92:	00005517          	auipc	a0,0x5
    1c96:	cce50513          	addi	a0,a0,-818 # 6960 <malloc+0xe80>
    1c9a:	00004097          	auipc	ra,0x4
    1c9e:	d88080e7          	jalr	-632(ra) # 5a22 <printf>
            exit(1);
    1ca2:	4505                	li	a0,1
    1ca4:	00004097          	auipc	ra,0x4
    1ca8:	a06080e7          	jalr	-1530(ra) # 56aa <exit>
      exit(0);
    1cac:	4501                	li	a0,0
    1cae:	00004097          	auipc	ra,0x4
    1cb2:	9fc080e7          	jalr	-1540(ra) # 56aa <exit>
      exit(1);
    1cb6:	4505                	li	a0,1
    1cb8:	00004097          	auipc	ra,0x4
    1cbc:	9f2080e7          	jalr	-1550(ra) # 56aa <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cc0:	f8040613          	addi	a2,s0,-128
    1cc4:	85e6                	mv	a1,s9
    1cc6:	00005517          	auipc	a0,0x5
    1cca:	cb250513          	addi	a0,a0,-846 # 6978 <malloc+0xe98>
    1cce:	00004097          	auipc	ra,0x4
    1cd2:	d54080e7          	jalr	-684(ra) # 5a22 <printf>
        exit(1);
    1cd6:	4505                	li	a0,1
    1cd8:	00004097          	auipc	ra,0x4
    1cdc:	9d2080e7          	jalr	-1582(ra) # 56aa <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ce0:	054b7163          	bgeu	s6,s4,1d22 <createdelete+0x198>
      if(fd >= 0)
    1ce4:	02055a63          	bgez	a0,1d18 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1ce8:	2485                	addiw	s1,s1,1
    1cea:	0ff4f493          	andi	s1,s1,255
    1cee:	05548c63          	beq	s1,s5,1d46 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1cf2:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1cf6:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1cfa:	4581                	li	a1,0
    1cfc:	f8040513          	addi	a0,s0,-128
    1d00:	00004097          	auipc	ra,0x4
    1d04:	9ea080e7          	jalr	-1558(ra) # 56ea <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d08:	00090463          	beqz	s2,1d10 <createdelete+0x186>
    1d0c:	fd2bdae3          	bge	s7,s2,1ce0 <createdelete+0x156>
    1d10:	fa0548e3          	bltz	a0,1cc0 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d14:	014b7963          	bgeu	s6,s4,1d26 <createdelete+0x19c>
        close(fd);
    1d18:	00004097          	auipc	ra,0x4
    1d1c:	9ba080e7          	jalr	-1606(ra) # 56d2 <close>
    1d20:	b7e1                	j	1ce8 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d22:	fc0543e3          	bltz	a0,1ce8 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d26:	f8040613          	addi	a2,s0,-128
    1d2a:	85e6                	mv	a1,s9
    1d2c:	00005517          	auipc	a0,0x5
    1d30:	c7450513          	addi	a0,a0,-908 # 69a0 <malloc+0xec0>
    1d34:	00004097          	auipc	ra,0x4
    1d38:	cee080e7          	jalr	-786(ra) # 5a22 <printf>
        exit(1);
    1d3c:	4505                	li	a0,1
    1d3e:	00004097          	auipc	ra,0x4
    1d42:	96c080e7          	jalr	-1684(ra) # 56aa <exit>
  for(i = 0; i < N; i++){
    1d46:	2905                	addiw	s2,s2,1
    1d48:	2a05                	addiw	s4,s4,1
    1d4a:	2985                	addiw	s3,s3,1
    1d4c:	0ff9f993          	andi	s3,s3,255
    1d50:	47d1                	li	a5,20
    1d52:	02f90a63          	beq	s2,a5,1d86 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d56:	84e2                	mv	s1,s8
    1d58:	bf69                	j	1cf2 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d5a:	2905                	addiw	s2,s2,1
    1d5c:	0ff97913          	andi	s2,s2,255
    1d60:	2985                	addiw	s3,s3,1
    1d62:	0ff9f993          	andi	s3,s3,255
    1d66:	03490863          	beq	s2,s4,1d96 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d6a:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d6c:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d70:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d74:	f8040513          	addi	a0,s0,-128
    1d78:	00004097          	auipc	ra,0x4
    1d7c:	982080e7          	jalr	-1662(ra) # 56fa <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1d80:	34fd                	addiw	s1,s1,-1
    1d82:	f4ed                	bnez	s1,1d6c <createdelete+0x1e2>
    1d84:	bfd9                	j	1d5a <createdelete+0x1d0>
    1d86:	03000993          	li	s3,48
    1d8a:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1d8e:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1d90:	08400a13          	li	s4,132
    1d94:	bfd9                	j	1d6a <createdelete+0x1e0>
}
    1d96:	60aa                	ld	ra,136(sp)
    1d98:	640a                	ld	s0,128(sp)
    1d9a:	74e6                	ld	s1,120(sp)
    1d9c:	7946                	ld	s2,112(sp)
    1d9e:	79a6                	ld	s3,104(sp)
    1da0:	7a06                	ld	s4,96(sp)
    1da2:	6ae6                	ld	s5,88(sp)
    1da4:	6b46                	ld	s6,80(sp)
    1da6:	6ba6                	ld	s7,72(sp)
    1da8:	6c06                	ld	s8,64(sp)
    1daa:	7ce2                	ld	s9,56(sp)
    1dac:	6149                	addi	sp,sp,144
    1dae:	8082                	ret

0000000000001db0 <linkunlink>:
{
    1db0:	711d                	addi	sp,sp,-96
    1db2:	ec86                	sd	ra,88(sp)
    1db4:	e8a2                	sd	s0,80(sp)
    1db6:	e4a6                	sd	s1,72(sp)
    1db8:	e0ca                	sd	s2,64(sp)
    1dba:	fc4e                	sd	s3,56(sp)
    1dbc:	f852                	sd	s4,48(sp)
    1dbe:	f456                	sd	s5,40(sp)
    1dc0:	f05a                	sd	s6,32(sp)
    1dc2:	ec5e                	sd	s7,24(sp)
    1dc4:	e862                	sd	s8,16(sp)
    1dc6:	e466                	sd	s9,8(sp)
    1dc8:	1080                	addi	s0,sp,96
    1dca:	84aa                	mv	s1,a0
  unlink("x");
    1dcc:	00004517          	auipc	a0,0x4
    1dd0:	1d450513          	addi	a0,a0,468 # 5fa0 <malloc+0x4c0>
    1dd4:	00004097          	auipc	ra,0x4
    1dd8:	926080e7          	jalr	-1754(ra) # 56fa <unlink>
  pid = fork();
    1ddc:	00004097          	auipc	ra,0x4
    1de0:	8c6080e7          	jalr	-1850(ra) # 56a2 <fork>
  if(pid < 0){
    1de4:	02054b63          	bltz	a0,1e1a <linkunlink+0x6a>
    1de8:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1dea:	4c85                	li	s9,1
    1dec:	e119                	bnez	a0,1df2 <linkunlink+0x42>
    1dee:	06100c93          	li	s9,97
    1df2:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1df6:	41c659b7          	lui	s3,0x41c65
    1dfa:	e6d9899b          	addiw	s3,s3,-403
    1dfe:	690d                	lui	s2,0x3
    1e00:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1e04:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e06:	4b05                	li	s6,1
      unlink("x");
    1e08:	00004a97          	auipc	s5,0x4
    1e0c:	198a8a93          	addi	s5,s5,408 # 5fa0 <malloc+0x4c0>
      link("cat", "x");
    1e10:	00005b97          	auipc	s7,0x5
    1e14:	bb8b8b93          	addi	s7,s7,-1096 # 69c8 <malloc+0xee8>
    1e18:	a091                	j	1e5c <linkunlink+0xac>
    printf("%s: fork failed\n", s);
    1e1a:	85a6                	mv	a1,s1
    1e1c:	00005517          	auipc	a0,0x5
    1e20:	95450513          	addi	a0,a0,-1708 # 6770 <malloc+0xc90>
    1e24:	00004097          	auipc	ra,0x4
    1e28:	bfe080e7          	jalr	-1026(ra) # 5a22 <printf>
    exit(1);
    1e2c:	4505                	li	a0,1
    1e2e:	00004097          	auipc	ra,0x4
    1e32:	87c080e7          	jalr	-1924(ra) # 56aa <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e36:	20200593          	li	a1,514
    1e3a:	8556                	mv	a0,s5
    1e3c:	00004097          	auipc	ra,0x4
    1e40:	8ae080e7          	jalr	-1874(ra) # 56ea <open>
    1e44:	00004097          	auipc	ra,0x4
    1e48:	88e080e7          	jalr	-1906(ra) # 56d2 <close>
    1e4c:	a031                	j	1e58 <linkunlink+0xa8>
      unlink("x");
    1e4e:	8556                	mv	a0,s5
    1e50:	00004097          	auipc	ra,0x4
    1e54:	8aa080e7          	jalr	-1878(ra) # 56fa <unlink>
  for(i = 0; i < 100; i++){
    1e58:	34fd                	addiw	s1,s1,-1
    1e5a:	c09d                	beqz	s1,1e80 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e5c:	033c87bb          	mulw	a5,s9,s3
    1e60:	012787bb          	addw	a5,a5,s2
    1e64:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e68:	0347f7bb          	remuw	a5,a5,s4
    1e6c:	d7e9                	beqz	a5,1e36 <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e6e:	ff6790e3          	bne	a5,s6,1e4e <linkunlink+0x9e>
      link("cat", "x");
    1e72:	85d6                	mv	a1,s5
    1e74:	855e                	mv	a0,s7
    1e76:	00004097          	auipc	ra,0x4
    1e7a:	894080e7          	jalr	-1900(ra) # 570a <link>
    1e7e:	bfe9                	j	1e58 <linkunlink+0xa8>
  if(pid)
    1e80:	020c0463          	beqz	s8,1ea8 <linkunlink+0xf8>
    wait(0);
    1e84:	4501                	li	a0,0
    1e86:	00004097          	auipc	ra,0x4
    1e8a:	82c080e7          	jalr	-2004(ra) # 56b2 <wait>
}
    1e8e:	60e6                	ld	ra,88(sp)
    1e90:	6446                	ld	s0,80(sp)
    1e92:	64a6                	ld	s1,72(sp)
    1e94:	6906                	ld	s2,64(sp)
    1e96:	79e2                	ld	s3,56(sp)
    1e98:	7a42                	ld	s4,48(sp)
    1e9a:	7aa2                	ld	s5,40(sp)
    1e9c:	7b02                	ld	s6,32(sp)
    1e9e:	6be2                	ld	s7,24(sp)
    1ea0:	6c42                	ld	s8,16(sp)
    1ea2:	6ca2                	ld	s9,8(sp)
    1ea4:	6125                	addi	sp,sp,96
    1ea6:	8082                	ret
    exit(0);
    1ea8:	4501                	li	a0,0
    1eaa:	00004097          	auipc	ra,0x4
    1eae:	800080e7          	jalr	-2048(ra) # 56aa <exit>

0000000000001eb2 <manywrites>:
{
    1eb2:	711d                	addi	sp,sp,-96
    1eb4:	ec86                	sd	ra,88(sp)
    1eb6:	e8a2                	sd	s0,80(sp)
    1eb8:	e4a6                	sd	s1,72(sp)
    1eba:	e0ca                	sd	s2,64(sp)
    1ebc:	fc4e                	sd	s3,56(sp)
    1ebe:	f852                	sd	s4,48(sp)
    1ec0:	f456                	sd	s5,40(sp)
    1ec2:	f05a                	sd	s6,32(sp)
    1ec4:	ec5e                	sd	s7,24(sp)
    1ec6:	1080                	addi	s0,sp,96
    1ec8:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1eca:	4901                	li	s2,0
    1ecc:	4991                	li	s3,4
    int pid = fork();
    1ece:	00003097          	auipc	ra,0x3
    1ed2:	7d4080e7          	jalr	2004(ra) # 56a2 <fork>
    1ed6:	84aa                	mv	s1,a0
    if(pid < 0){
    1ed8:	02054963          	bltz	a0,1f0a <manywrites+0x58>
    if(pid == 0){
    1edc:	c521                	beqz	a0,1f24 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    1ede:	2905                	addiw	s2,s2,1
    1ee0:	ff3917e3          	bne	s2,s3,1ece <manywrites+0x1c>
    1ee4:	4491                	li	s1,4
    int st = 0;
    1ee6:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1eea:	fa840513          	addi	a0,s0,-88
    1eee:	00003097          	auipc	ra,0x3
    1ef2:	7c4080e7          	jalr	1988(ra) # 56b2 <wait>
    if(st != 0)
    1ef6:	fa842503          	lw	a0,-88(s0)
    1efa:	ed6d                	bnez	a0,1ff4 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    1efc:	34fd                	addiw	s1,s1,-1
    1efe:	f4e5                	bnez	s1,1ee6 <manywrites+0x34>
  exit(0);
    1f00:	4501                	li	a0,0
    1f02:	00003097          	auipc	ra,0x3
    1f06:	7a8080e7          	jalr	1960(ra) # 56aa <exit>
      printf("fork failed\n");
    1f0a:	00005517          	auipc	a0,0x5
    1f0e:	c6e50513          	addi	a0,a0,-914 # 6b78 <malloc+0x1098>
    1f12:	00004097          	auipc	ra,0x4
    1f16:	b10080e7          	jalr	-1264(ra) # 5a22 <printf>
      exit(1);
    1f1a:	4505                	li	a0,1
    1f1c:	00003097          	auipc	ra,0x3
    1f20:	78e080e7          	jalr	1934(ra) # 56aa <exit>
      name[0] = 'b';
    1f24:	06200793          	li	a5,98
    1f28:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1f2c:	0619079b          	addiw	a5,s2,97
    1f30:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1f34:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1f38:	fa840513          	addi	a0,s0,-88
    1f3c:	00003097          	auipc	ra,0x3
    1f40:	7be080e7          	jalr	1982(ra) # 56fa <unlink>
    1f44:	4b79                	li	s6,30
          int cc = write(fd, buf, sz);
    1f46:	0000ab97          	auipc	s7,0xa
    1f4a:	c3ab8b93          	addi	s7,s7,-966 # bb80 <buf>
        for(int i = 0; i < ci+1; i++){
    1f4e:	8a26                	mv	s4,s1
    1f50:	02094e63          	bltz	s2,1f8c <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    1f54:	20200593          	li	a1,514
    1f58:	fa840513          	addi	a0,s0,-88
    1f5c:	00003097          	auipc	ra,0x3
    1f60:	78e080e7          	jalr	1934(ra) # 56ea <open>
    1f64:	89aa                	mv	s3,a0
          if(fd < 0){
    1f66:	04054763          	bltz	a0,1fb4 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    1f6a:	660d                	lui	a2,0x3
    1f6c:	85de                	mv	a1,s7
    1f6e:	00003097          	auipc	ra,0x3
    1f72:	75c080e7          	jalr	1884(ra) # 56ca <write>
          if(cc != sz){
    1f76:	678d                	lui	a5,0x3
    1f78:	04f51e63          	bne	a0,a5,1fd4 <manywrites+0x122>
          close(fd);
    1f7c:	854e                	mv	a0,s3
    1f7e:	00003097          	auipc	ra,0x3
    1f82:	754080e7          	jalr	1876(ra) # 56d2 <close>
        for(int i = 0; i < ci+1; i++){
    1f86:	2a05                	addiw	s4,s4,1
    1f88:	fd4956e3          	bge	s2,s4,1f54 <manywrites+0xa2>
        unlink(name);
    1f8c:	fa840513          	addi	a0,s0,-88
    1f90:	00003097          	auipc	ra,0x3
    1f94:	76a080e7          	jalr	1898(ra) # 56fa <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1f98:	3b7d                	addiw	s6,s6,-1
    1f9a:	fa0b1ae3          	bnez	s6,1f4e <manywrites+0x9c>
      unlink(name);
    1f9e:	fa840513          	addi	a0,s0,-88
    1fa2:	00003097          	auipc	ra,0x3
    1fa6:	758080e7          	jalr	1880(ra) # 56fa <unlink>
      exit(0);
    1faa:	4501                	li	a0,0
    1fac:	00003097          	auipc	ra,0x3
    1fb0:	6fe080e7          	jalr	1790(ra) # 56aa <exit>
            printf("%s: cannot create %s\n", s, name);
    1fb4:	fa840613          	addi	a2,s0,-88
    1fb8:	85d6                	mv	a1,s5
    1fba:	00005517          	auipc	a0,0x5
    1fbe:	a1650513          	addi	a0,a0,-1514 # 69d0 <malloc+0xef0>
    1fc2:	00004097          	auipc	ra,0x4
    1fc6:	a60080e7          	jalr	-1440(ra) # 5a22 <printf>
            exit(1);
    1fca:	4505                	li	a0,1
    1fcc:	00003097          	auipc	ra,0x3
    1fd0:	6de080e7          	jalr	1758(ra) # 56aa <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1fd4:	86aa                	mv	a3,a0
    1fd6:	660d                	lui	a2,0x3
    1fd8:	85d6                	mv	a1,s5
    1fda:	00004517          	auipc	a0,0x4
    1fde:	01650513          	addi	a0,a0,22 # 5ff0 <malloc+0x510>
    1fe2:	00004097          	auipc	ra,0x4
    1fe6:	a40080e7          	jalr	-1472(ra) # 5a22 <printf>
            exit(1);
    1fea:	4505                	li	a0,1
    1fec:	00003097          	auipc	ra,0x3
    1ff0:	6be080e7          	jalr	1726(ra) # 56aa <exit>
      exit(st);
    1ff4:	00003097          	auipc	ra,0x3
    1ff8:	6b6080e7          	jalr	1718(ra) # 56aa <exit>

0000000000001ffc <forktest>:
{
    1ffc:	7179                	addi	sp,sp,-48
    1ffe:	f406                	sd	ra,40(sp)
    2000:	f022                	sd	s0,32(sp)
    2002:	ec26                	sd	s1,24(sp)
    2004:	e84a                	sd	s2,16(sp)
    2006:	e44e                	sd	s3,8(sp)
    2008:	1800                	addi	s0,sp,48
    200a:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    200c:	4481                	li	s1,0
    200e:	3e800913          	li	s2,1000
    pid = fork();
    2012:	00003097          	auipc	ra,0x3
    2016:	690080e7          	jalr	1680(ra) # 56a2 <fork>
    if(pid < 0)
    201a:	02054863          	bltz	a0,204a <forktest+0x4e>
    if(pid == 0)
    201e:	c115                	beqz	a0,2042 <forktest+0x46>
  for(n=0; n<N; n++){
    2020:	2485                	addiw	s1,s1,1
    2022:	ff2498e3          	bne	s1,s2,2012 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    2026:	85ce                	mv	a1,s3
    2028:	00005517          	auipc	a0,0x5
    202c:	9d850513          	addi	a0,a0,-1576 # 6a00 <malloc+0xf20>
    2030:	00004097          	auipc	ra,0x4
    2034:	9f2080e7          	jalr	-1550(ra) # 5a22 <printf>
    exit(1);
    2038:	4505                	li	a0,1
    203a:	00003097          	auipc	ra,0x3
    203e:	670080e7          	jalr	1648(ra) # 56aa <exit>
      exit(0);
    2042:	00003097          	auipc	ra,0x3
    2046:	668080e7          	jalr	1640(ra) # 56aa <exit>
  if (n == 0) {
    204a:	cc9d                	beqz	s1,2088 <forktest+0x8c>
  if(n == N){
    204c:	3e800793          	li	a5,1000
    2050:	fcf48be3          	beq	s1,a5,2026 <forktest+0x2a>
  for(; n > 0; n--){
    2054:	00905b63          	blez	s1,206a <forktest+0x6e>
    if(wait(0) < 0){
    2058:	4501                	li	a0,0
    205a:	00003097          	auipc	ra,0x3
    205e:	658080e7          	jalr	1624(ra) # 56b2 <wait>
    2062:	04054163          	bltz	a0,20a4 <forktest+0xa8>
  for(; n > 0; n--){
    2066:	34fd                	addiw	s1,s1,-1
    2068:	f8e5                	bnez	s1,2058 <forktest+0x5c>
  if(wait(0) != -1){
    206a:	4501                	li	a0,0
    206c:	00003097          	auipc	ra,0x3
    2070:	646080e7          	jalr	1606(ra) # 56b2 <wait>
    2074:	57fd                	li	a5,-1
    2076:	04f51563          	bne	a0,a5,20c0 <forktest+0xc4>
}
    207a:	70a2                	ld	ra,40(sp)
    207c:	7402                	ld	s0,32(sp)
    207e:	64e2                	ld	s1,24(sp)
    2080:	6942                	ld	s2,16(sp)
    2082:	69a2                	ld	s3,8(sp)
    2084:	6145                	addi	sp,sp,48
    2086:	8082                	ret
    printf("%s: no fork at all!\n", s);
    2088:	85ce                	mv	a1,s3
    208a:	00005517          	auipc	a0,0x5
    208e:	95e50513          	addi	a0,a0,-1698 # 69e8 <malloc+0xf08>
    2092:	00004097          	auipc	ra,0x4
    2096:	990080e7          	jalr	-1648(ra) # 5a22 <printf>
    exit(1);
    209a:	4505                	li	a0,1
    209c:	00003097          	auipc	ra,0x3
    20a0:	60e080e7          	jalr	1550(ra) # 56aa <exit>
      printf("%s: wait stopped early\n", s);
    20a4:	85ce                	mv	a1,s3
    20a6:	00005517          	auipc	a0,0x5
    20aa:	98250513          	addi	a0,a0,-1662 # 6a28 <malloc+0xf48>
    20ae:	00004097          	auipc	ra,0x4
    20b2:	974080e7          	jalr	-1676(ra) # 5a22 <printf>
      exit(1);
    20b6:	4505                	li	a0,1
    20b8:	00003097          	auipc	ra,0x3
    20bc:	5f2080e7          	jalr	1522(ra) # 56aa <exit>
    printf("%s: wait got too many\n", s);
    20c0:	85ce                	mv	a1,s3
    20c2:	00005517          	auipc	a0,0x5
    20c6:	97e50513          	addi	a0,a0,-1666 # 6a40 <malloc+0xf60>
    20ca:	00004097          	auipc	ra,0x4
    20ce:	958080e7          	jalr	-1704(ra) # 5a22 <printf>
    exit(1);
    20d2:	4505                	li	a0,1
    20d4:	00003097          	auipc	ra,0x3
    20d8:	5d6080e7          	jalr	1494(ra) # 56aa <exit>

00000000000020dc <kernmem>:
{
    20dc:	715d                	addi	sp,sp,-80
    20de:	e486                	sd	ra,72(sp)
    20e0:	e0a2                	sd	s0,64(sp)
    20e2:	fc26                	sd	s1,56(sp)
    20e4:	f84a                	sd	s2,48(sp)
    20e6:	f44e                	sd	s3,40(sp)
    20e8:	f052                	sd	s4,32(sp)
    20ea:	ec56                	sd	s5,24(sp)
    20ec:	0880                	addi	s0,sp,80
    20ee:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20f0:	4485                	li	s1,1
    20f2:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    20f4:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20f6:	69b1                	lui	s3,0xc
    20f8:	35098993          	addi	s3,s3,848 # c350 <buf+0x7d0>
    20fc:	1003d937          	lui	s2,0x1003d
    2100:	090e                	slli	s2,s2,0x3
    2102:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002e8f0>
    pid = fork();
    2106:	00003097          	auipc	ra,0x3
    210a:	59c080e7          	jalr	1436(ra) # 56a2 <fork>
    if(pid < 0){
    210e:	02054963          	bltz	a0,2140 <kernmem+0x64>
    if(pid == 0){
    2112:	c529                	beqz	a0,215c <kernmem+0x80>
    wait(&xstatus);
    2114:	fbc40513          	addi	a0,s0,-68
    2118:	00003097          	auipc	ra,0x3
    211c:	59a080e7          	jalr	1434(ra) # 56b2 <wait>
    if(xstatus != -1)  // did kernel kill child?
    2120:	fbc42783          	lw	a5,-68(s0)
    2124:	05579d63          	bne	a5,s5,217e <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2128:	94ce                	add	s1,s1,s3
    212a:	fd249ee3          	bne	s1,s2,2106 <kernmem+0x2a>
}
    212e:	60a6                	ld	ra,72(sp)
    2130:	6406                	ld	s0,64(sp)
    2132:	74e2                	ld	s1,56(sp)
    2134:	7942                	ld	s2,48(sp)
    2136:	79a2                	ld	s3,40(sp)
    2138:	7a02                	ld	s4,32(sp)
    213a:	6ae2                	ld	s5,24(sp)
    213c:	6161                	addi	sp,sp,80
    213e:	8082                	ret
      printf("%s: fork failed\n", s);
    2140:	85d2                	mv	a1,s4
    2142:	00004517          	auipc	a0,0x4
    2146:	62e50513          	addi	a0,a0,1582 # 6770 <malloc+0xc90>
    214a:	00004097          	auipc	ra,0x4
    214e:	8d8080e7          	jalr	-1832(ra) # 5a22 <printf>
      exit(1);
    2152:	4505                	li	a0,1
    2154:	00003097          	auipc	ra,0x3
    2158:	556080e7          	jalr	1366(ra) # 56aa <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    215c:	0004c683          	lbu	a3,0(s1)
    2160:	8626                	mv	a2,s1
    2162:	85d2                	mv	a1,s4
    2164:	00005517          	auipc	a0,0x5
    2168:	8f450513          	addi	a0,a0,-1804 # 6a58 <malloc+0xf78>
    216c:	00004097          	auipc	ra,0x4
    2170:	8b6080e7          	jalr	-1866(ra) # 5a22 <printf>
      exit(1);
    2174:	4505                	li	a0,1
    2176:	00003097          	auipc	ra,0x3
    217a:	534080e7          	jalr	1332(ra) # 56aa <exit>
      exit(1);
    217e:	4505                	li	a0,1
    2180:	00003097          	auipc	ra,0x3
    2184:	52a080e7          	jalr	1322(ra) # 56aa <exit>

0000000000002188 <bigargtest>:
{
    2188:	7179                	addi	sp,sp,-48
    218a:	f406                	sd	ra,40(sp)
    218c:	f022                	sd	s0,32(sp)
    218e:	ec26                	sd	s1,24(sp)
    2190:	1800                	addi	s0,sp,48
    2192:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    2194:	00005517          	auipc	a0,0x5
    2198:	8e450513          	addi	a0,a0,-1820 # 6a78 <malloc+0xf98>
    219c:	00003097          	auipc	ra,0x3
    21a0:	55e080e7          	jalr	1374(ra) # 56fa <unlink>
  pid = fork();
    21a4:	00003097          	auipc	ra,0x3
    21a8:	4fe080e7          	jalr	1278(ra) # 56a2 <fork>
  if(pid == 0){
    21ac:	c121                	beqz	a0,21ec <bigargtest+0x64>
  } else if(pid < 0){
    21ae:	0a054063          	bltz	a0,224e <bigargtest+0xc6>
  wait(&xstatus);
    21b2:	fdc40513          	addi	a0,s0,-36
    21b6:	00003097          	auipc	ra,0x3
    21ba:	4fc080e7          	jalr	1276(ra) # 56b2 <wait>
  if(xstatus != 0)
    21be:	fdc42503          	lw	a0,-36(s0)
    21c2:	e545                	bnez	a0,226a <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    21c4:	4581                	li	a1,0
    21c6:	00005517          	auipc	a0,0x5
    21ca:	8b250513          	addi	a0,a0,-1870 # 6a78 <malloc+0xf98>
    21ce:	00003097          	auipc	ra,0x3
    21d2:	51c080e7          	jalr	1308(ra) # 56ea <open>
  if(fd < 0){
    21d6:	08054e63          	bltz	a0,2272 <bigargtest+0xea>
  close(fd);
    21da:	00003097          	auipc	ra,0x3
    21de:	4f8080e7          	jalr	1272(ra) # 56d2 <close>
}
    21e2:	70a2                	ld	ra,40(sp)
    21e4:	7402                	ld	s0,32(sp)
    21e6:	64e2                	ld	s1,24(sp)
    21e8:	6145                	addi	sp,sp,48
    21ea:	8082                	ret
    21ec:	00006797          	auipc	a5,0x6
    21f0:	17c78793          	addi	a5,a5,380 # 8368 <args.1844>
    21f4:	00006697          	auipc	a3,0x6
    21f8:	26c68693          	addi	a3,a3,620 # 8460 <args.1844+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    21fc:	00005717          	auipc	a4,0x5
    2200:	88c70713          	addi	a4,a4,-1908 # 6a88 <malloc+0xfa8>
    2204:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    2206:	07a1                	addi	a5,a5,8
    2208:	fed79ee3          	bne	a5,a3,2204 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    220c:	00006597          	auipc	a1,0x6
    2210:	15c58593          	addi	a1,a1,348 # 8368 <args.1844>
    2214:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2218:	00004517          	auipc	a0,0x4
    221c:	d1850513          	addi	a0,a0,-744 # 5f30 <malloc+0x450>
    2220:	00003097          	auipc	ra,0x3
    2224:	4c2080e7          	jalr	1218(ra) # 56e2 <exec>
    fd = open("bigarg-ok", O_CREATE);
    2228:	20000593          	li	a1,512
    222c:	00005517          	auipc	a0,0x5
    2230:	84c50513          	addi	a0,a0,-1972 # 6a78 <malloc+0xf98>
    2234:	00003097          	auipc	ra,0x3
    2238:	4b6080e7          	jalr	1206(ra) # 56ea <open>
    close(fd);
    223c:	00003097          	auipc	ra,0x3
    2240:	496080e7          	jalr	1174(ra) # 56d2 <close>
    exit(0);
    2244:	4501                	li	a0,0
    2246:	00003097          	auipc	ra,0x3
    224a:	464080e7          	jalr	1124(ra) # 56aa <exit>
    printf("%s: bigargtest: fork failed\n", s);
    224e:	85a6                	mv	a1,s1
    2250:	00005517          	auipc	a0,0x5
    2254:	91850513          	addi	a0,a0,-1768 # 6b68 <malloc+0x1088>
    2258:	00003097          	auipc	ra,0x3
    225c:	7ca080e7          	jalr	1994(ra) # 5a22 <printf>
    exit(1);
    2260:	4505                	li	a0,1
    2262:	00003097          	auipc	ra,0x3
    2266:	448080e7          	jalr	1096(ra) # 56aa <exit>
    exit(xstatus);
    226a:	00003097          	auipc	ra,0x3
    226e:	440080e7          	jalr	1088(ra) # 56aa <exit>
    printf("%s: bigarg test failed!\n", s);
    2272:	85a6                	mv	a1,s1
    2274:	00005517          	auipc	a0,0x5
    2278:	91450513          	addi	a0,a0,-1772 # 6b88 <malloc+0x10a8>
    227c:	00003097          	auipc	ra,0x3
    2280:	7a6080e7          	jalr	1958(ra) # 5a22 <printf>
    exit(1);
    2284:	4505                	li	a0,1
    2286:	00003097          	auipc	ra,0x3
    228a:	424080e7          	jalr	1060(ra) # 56aa <exit>

000000000000228e <stacktest>:
{
    228e:	7179                	addi	sp,sp,-48
    2290:	f406                	sd	ra,40(sp)
    2292:	f022                	sd	s0,32(sp)
    2294:	ec26                	sd	s1,24(sp)
    2296:	1800                	addi	s0,sp,48
    2298:	84aa                	mv	s1,a0
  pid = fork();
    229a:	00003097          	auipc	ra,0x3
    229e:	408080e7          	jalr	1032(ra) # 56a2 <fork>
  if(pid == 0) {
    22a2:	c115                	beqz	a0,22c6 <stacktest+0x38>
  } else if(pid < 0){
    22a4:	04054463          	bltz	a0,22ec <stacktest+0x5e>
  wait(&xstatus);
    22a8:	fdc40513          	addi	a0,s0,-36
    22ac:	00003097          	auipc	ra,0x3
    22b0:	406080e7          	jalr	1030(ra) # 56b2 <wait>
  if(xstatus == -1)  // kernel killed child?
    22b4:	fdc42503          	lw	a0,-36(s0)
    22b8:	57fd                	li	a5,-1
    22ba:	04f50763          	beq	a0,a5,2308 <stacktest+0x7a>
    exit(xstatus);
    22be:	00003097          	auipc	ra,0x3
    22c2:	3ec080e7          	jalr	1004(ra) # 56aa <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    22c6:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    22c8:	77fd                	lui	a5,0xfffff
    22ca:	97ba                	add	a5,a5,a4
    22cc:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff0470>
    22d0:	85a6                	mv	a1,s1
    22d2:	00005517          	auipc	a0,0x5
    22d6:	8d650513          	addi	a0,a0,-1834 # 6ba8 <malloc+0x10c8>
    22da:	00003097          	auipc	ra,0x3
    22de:	748080e7          	jalr	1864(ra) # 5a22 <printf>
    exit(1);
    22e2:	4505                	li	a0,1
    22e4:	00003097          	auipc	ra,0x3
    22e8:	3c6080e7          	jalr	966(ra) # 56aa <exit>
    printf("%s: fork failed\n", s);
    22ec:	85a6                	mv	a1,s1
    22ee:	00004517          	auipc	a0,0x4
    22f2:	48250513          	addi	a0,a0,1154 # 6770 <malloc+0xc90>
    22f6:	00003097          	auipc	ra,0x3
    22fa:	72c080e7          	jalr	1836(ra) # 5a22 <printf>
    exit(1);
    22fe:	4505                	li	a0,1
    2300:	00003097          	auipc	ra,0x3
    2304:	3aa080e7          	jalr	938(ra) # 56aa <exit>
    exit(0);
    2308:	4501                	li	a0,0
    230a:	00003097          	auipc	ra,0x3
    230e:	3a0080e7          	jalr	928(ra) # 56aa <exit>

0000000000002312 <copyinstr3>:
{
    2312:	7179                	addi	sp,sp,-48
    2314:	f406                	sd	ra,40(sp)
    2316:	f022                	sd	s0,32(sp)
    2318:	ec26                	sd	s1,24(sp)
    231a:	1800                	addi	s0,sp,48
  sbrk(8192);
    231c:	6509                	lui	a0,0x2
    231e:	00003097          	auipc	ra,0x3
    2322:	414080e7          	jalr	1044(ra) # 5732 <sbrk>
  uint64 top = (uint64) sbrk(0);
    2326:	4501                	li	a0,0
    2328:	00003097          	auipc	ra,0x3
    232c:	40a080e7          	jalr	1034(ra) # 5732 <sbrk>
  if((top % PGSIZE) != 0){
    2330:	03451793          	slli	a5,a0,0x34
    2334:	e3c9                	bnez	a5,23b6 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2336:	4501                	li	a0,0
    2338:	00003097          	auipc	ra,0x3
    233c:	3fa080e7          	jalr	1018(ra) # 5732 <sbrk>
  if(top % PGSIZE){
    2340:	03451793          	slli	a5,a0,0x34
    2344:	e3d9                	bnez	a5,23ca <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2346:	fff50493          	addi	s1,a0,-1 # 1fff <forktest+0x3>
  *b = 'x';
    234a:	07800793          	li	a5,120
    234e:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2352:	8526                	mv	a0,s1
    2354:	00003097          	auipc	ra,0x3
    2358:	3a6080e7          	jalr	934(ra) # 56fa <unlink>
  if(ret != -1){
    235c:	57fd                	li	a5,-1
    235e:	08f51363          	bne	a0,a5,23e4 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2362:	20100593          	li	a1,513
    2366:	8526                	mv	a0,s1
    2368:	00003097          	auipc	ra,0x3
    236c:	382080e7          	jalr	898(ra) # 56ea <open>
  if(fd != -1){
    2370:	57fd                	li	a5,-1
    2372:	08f51863          	bne	a0,a5,2402 <copyinstr3+0xf0>
  ret = link(b, b);
    2376:	85a6                	mv	a1,s1
    2378:	8526                	mv	a0,s1
    237a:	00003097          	auipc	ra,0x3
    237e:	390080e7          	jalr	912(ra) # 570a <link>
  if(ret != -1){
    2382:	57fd                	li	a5,-1
    2384:	08f51e63          	bne	a0,a5,2420 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2388:	00005797          	auipc	a5,0x5
    238c:	4b878793          	addi	a5,a5,1208 # 7840 <malloc+0x1d60>
    2390:	fcf43823          	sd	a5,-48(s0)
    2394:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2398:	fd040593          	addi	a1,s0,-48
    239c:	8526                	mv	a0,s1
    239e:	00003097          	auipc	ra,0x3
    23a2:	344080e7          	jalr	836(ra) # 56e2 <exec>
  if(ret != -1){
    23a6:	57fd                	li	a5,-1
    23a8:	08f51c63          	bne	a0,a5,2440 <copyinstr3+0x12e>
}
    23ac:	70a2                	ld	ra,40(sp)
    23ae:	7402                	ld	s0,32(sp)
    23b0:	64e2                	ld	s1,24(sp)
    23b2:	6145                	addi	sp,sp,48
    23b4:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    23b6:	0347d513          	srli	a0,a5,0x34
    23ba:	6785                	lui	a5,0x1
    23bc:	40a7853b          	subw	a0,a5,a0
    23c0:	00003097          	auipc	ra,0x3
    23c4:	372080e7          	jalr	882(ra) # 5732 <sbrk>
    23c8:	b7bd                	j	2336 <copyinstr3+0x24>
    printf("oops\n");
    23ca:	00005517          	auipc	a0,0x5
    23ce:	80650513          	addi	a0,a0,-2042 # 6bd0 <malloc+0x10f0>
    23d2:	00003097          	auipc	ra,0x3
    23d6:	650080e7          	jalr	1616(ra) # 5a22 <printf>
    exit(1);
    23da:	4505                	li	a0,1
    23dc:	00003097          	auipc	ra,0x3
    23e0:	2ce080e7          	jalr	718(ra) # 56aa <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    23e4:	862a                	mv	a2,a0
    23e6:	85a6                	mv	a1,s1
    23e8:	00004517          	auipc	a0,0x4
    23ec:	2a850513          	addi	a0,a0,680 # 6690 <malloc+0xbb0>
    23f0:	00003097          	auipc	ra,0x3
    23f4:	632080e7          	jalr	1586(ra) # 5a22 <printf>
    exit(1);
    23f8:	4505                	li	a0,1
    23fa:	00003097          	auipc	ra,0x3
    23fe:	2b0080e7          	jalr	688(ra) # 56aa <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2402:	862a                	mv	a2,a0
    2404:	85a6                	mv	a1,s1
    2406:	00004517          	auipc	a0,0x4
    240a:	2aa50513          	addi	a0,a0,682 # 66b0 <malloc+0xbd0>
    240e:	00003097          	auipc	ra,0x3
    2412:	614080e7          	jalr	1556(ra) # 5a22 <printf>
    exit(1);
    2416:	4505                	li	a0,1
    2418:	00003097          	auipc	ra,0x3
    241c:	292080e7          	jalr	658(ra) # 56aa <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2420:	86aa                	mv	a3,a0
    2422:	8626                	mv	a2,s1
    2424:	85a6                	mv	a1,s1
    2426:	00004517          	auipc	a0,0x4
    242a:	2aa50513          	addi	a0,a0,682 # 66d0 <malloc+0xbf0>
    242e:	00003097          	auipc	ra,0x3
    2432:	5f4080e7          	jalr	1524(ra) # 5a22 <printf>
    exit(1);
    2436:	4505                	li	a0,1
    2438:	00003097          	auipc	ra,0x3
    243c:	272080e7          	jalr	626(ra) # 56aa <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2440:	567d                	li	a2,-1
    2442:	85a6                	mv	a1,s1
    2444:	00004517          	auipc	a0,0x4
    2448:	2b450513          	addi	a0,a0,692 # 66f8 <malloc+0xc18>
    244c:	00003097          	auipc	ra,0x3
    2450:	5d6080e7          	jalr	1494(ra) # 5a22 <printf>
    exit(1);
    2454:	4505                	li	a0,1
    2456:	00003097          	auipc	ra,0x3
    245a:	254080e7          	jalr	596(ra) # 56aa <exit>

000000000000245e <rwsbrk>:
{
    245e:	1101                	addi	sp,sp,-32
    2460:	ec06                	sd	ra,24(sp)
    2462:	e822                	sd	s0,16(sp)
    2464:	e426                	sd	s1,8(sp)
    2466:	e04a                	sd	s2,0(sp)
    2468:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    246a:	6509                	lui	a0,0x2
    246c:	00003097          	auipc	ra,0x3
    2470:	2c6080e7          	jalr	710(ra) # 5732 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2474:	57fd                	li	a5,-1
    2476:	06f50363          	beq	a0,a5,24dc <rwsbrk+0x7e>
    247a:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    247c:	7579                	lui	a0,0xffffe
    247e:	00003097          	auipc	ra,0x3
    2482:	2b4080e7          	jalr	692(ra) # 5732 <sbrk>
    2486:	57fd                	li	a5,-1
    2488:	06f50763          	beq	a0,a5,24f6 <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    248c:	20100593          	li	a1,513
    2490:	00003517          	auipc	a0,0x3
    2494:	7b050513          	addi	a0,a0,1968 # 5c40 <malloc+0x160>
    2498:	00003097          	auipc	ra,0x3
    249c:	252080e7          	jalr	594(ra) # 56ea <open>
    24a0:	892a                	mv	s2,a0
  if(fd < 0){
    24a2:	06054763          	bltz	a0,2510 <rwsbrk+0xb2>
  n = write(fd, (void*)(a+4096), 1024);
    24a6:	6505                	lui	a0,0x1
    24a8:	94aa                	add	s1,s1,a0
    24aa:	40000613          	li	a2,1024
    24ae:	85a6                	mv	a1,s1
    24b0:	854a                	mv	a0,s2
    24b2:	00003097          	auipc	ra,0x3
    24b6:	218080e7          	jalr	536(ra) # 56ca <write>
    24ba:	862a                	mv	a2,a0
  if(n >= 0){
    24bc:	06054763          	bltz	a0,252a <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    24c0:	85a6                	mv	a1,s1
    24c2:	00004517          	auipc	a0,0x4
    24c6:	76650513          	addi	a0,a0,1894 # 6c28 <malloc+0x1148>
    24ca:	00003097          	auipc	ra,0x3
    24ce:	558080e7          	jalr	1368(ra) # 5a22 <printf>
    exit(1);
    24d2:	4505                	li	a0,1
    24d4:	00003097          	auipc	ra,0x3
    24d8:	1d6080e7          	jalr	470(ra) # 56aa <exit>
    printf("sbrk(rwsbrk) failed\n");
    24dc:	00004517          	auipc	a0,0x4
    24e0:	6fc50513          	addi	a0,a0,1788 # 6bd8 <malloc+0x10f8>
    24e4:	00003097          	auipc	ra,0x3
    24e8:	53e080e7          	jalr	1342(ra) # 5a22 <printf>
    exit(1);
    24ec:	4505                	li	a0,1
    24ee:	00003097          	auipc	ra,0x3
    24f2:	1bc080e7          	jalr	444(ra) # 56aa <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    24f6:	00004517          	auipc	a0,0x4
    24fa:	6fa50513          	addi	a0,a0,1786 # 6bf0 <malloc+0x1110>
    24fe:	00003097          	auipc	ra,0x3
    2502:	524080e7          	jalr	1316(ra) # 5a22 <printf>
    exit(1);
    2506:	4505                	li	a0,1
    2508:	00003097          	auipc	ra,0x3
    250c:	1a2080e7          	jalr	418(ra) # 56aa <exit>
    printf("open(rwsbrk) failed\n");
    2510:	00004517          	auipc	a0,0x4
    2514:	70050513          	addi	a0,a0,1792 # 6c10 <malloc+0x1130>
    2518:	00003097          	auipc	ra,0x3
    251c:	50a080e7          	jalr	1290(ra) # 5a22 <printf>
    exit(1);
    2520:	4505                	li	a0,1
    2522:	00003097          	auipc	ra,0x3
    2526:	188080e7          	jalr	392(ra) # 56aa <exit>
  close(fd);
    252a:	854a                	mv	a0,s2
    252c:	00003097          	auipc	ra,0x3
    2530:	1a6080e7          	jalr	422(ra) # 56d2 <close>
  unlink("rwsbrk");
    2534:	00003517          	auipc	a0,0x3
    2538:	70c50513          	addi	a0,a0,1804 # 5c40 <malloc+0x160>
    253c:	00003097          	auipc	ra,0x3
    2540:	1be080e7          	jalr	446(ra) # 56fa <unlink>
  fd = open("README.md", O_RDONLY);
    2544:	4581                	li	a1,0
    2546:	00004517          	auipc	a0,0x4
    254a:	b8250513          	addi	a0,a0,-1150 # 60c8 <malloc+0x5e8>
    254e:	00003097          	auipc	ra,0x3
    2552:	19c080e7          	jalr	412(ra) # 56ea <open>
    2556:	892a                	mv	s2,a0
  if(fd < 0){
    2558:	02054963          	bltz	a0,258a <rwsbrk+0x12c>
  n = read(fd, (void*)(a+4096), 10);
    255c:	4629                	li	a2,10
    255e:	85a6                	mv	a1,s1
    2560:	00003097          	auipc	ra,0x3
    2564:	162080e7          	jalr	354(ra) # 56c2 <read>
    2568:	862a                	mv	a2,a0
  if(n >= 0){
    256a:	02054d63          	bltz	a0,25a4 <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    256e:	85a6                	mv	a1,s1
    2570:	00004517          	auipc	a0,0x4
    2574:	6e850513          	addi	a0,a0,1768 # 6c58 <malloc+0x1178>
    2578:	00003097          	auipc	ra,0x3
    257c:	4aa080e7          	jalr	1194(ra) # 5a22 <printf>
    exit(1);
    2580:	4505                	li	a0,1
    2582:	00003097          	auipc	ra,0x3
    2586:	128080e7          	jalr	296(ra) # 56aa <exit>
    printf("open(rwsbrk) failed\n");
    258a:	00004517          	auipc	a0,0x4
    258e:	68650513          	addi	a0,a0,1670 # 6c10 <malloc+0x1130>
    2592:	00003097          	auipc	ra,0x3
    2596:	490080e7          	jalr	1168(ra) # 5a22 <printf>
    exit(1);
    259a:	4505                	li	a0,1
    259c:	00003097          	auipc	ra,0x3
    25a0:	10e080e7          	jalr	270(ra) # 56aa <exit>
  close(fd);
    25a4:	854a                	mv	a0,s2
    25a6:	00003097          	auipc	ra,0x3
    25aa:	12c080e7          	jalr	300(ra) # 56d2 <close>
  exit(0);
    25ae:	4501                	li	a0,0
    25b0:	00003097          	auipc	ra,0x3
    25b4:	0fa080e7          	jalr	250(ra) # 56aa <exit>

00000000000025b8 <sbrkbasic>:
{
    25b8:	715d                	addi	sp,sp,-80
    25ba:	e486                	sd	ra,72(sp)
    25bc:	e0a2                	sd	s0,64(sp)
    25be:	fc26                	sd	s1,56(sp)
    25c0:	f84a                	sd	s2,48(sp)
    25c2:	f44e                	sd	s3,40(sp)
    25c4:	f052                	sd	s4,32(sp)
    25c6:	ec56                	sd	s5,24(sp)
    25c8:	0880                	addi	s0,sp,80
    25ca:	8a2a                	mv	s4,a0
  pid = fork();
    25cc:	00003097          	auipc	ra,0x3
    25d0:	0d6080e7          	jalr	214(ra) # 56a2 <fork>
  if(pid < 0){
    25d4:	02054c63          	bltz	a0,260c <sbrkbasic+0x54>
  if(pid == 0){
    25d8:	ed21                	bnez	a0,2630 <sbrkbasic+0x78>
    a = sbrk(TOOMUCH);
    25da:	40000537          	lui	a0,0x40000
    25de:	00003097          	auipc	ra,0x3
    25e2:	154080e7          	jalr	340(ra) # 5732 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    25e6:	57fd                	li	a5,-1
    25e8:	02f50f63          	beq	a0,a5,2626 <sbrkbasic+0x6e>
    for(b = a; b < a+TOOMUCH; b += 4096){
    25ec:	400007b7          	lui	a5,0x40000
    25f0:	97aa                	add	a5,a5,a0
      *b = 99;
    25f2:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    25f6:	6705                	lui	a4,0x1
      *b = 99;
    25f8:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff1470>
    for(b = a; b < a+TOOMUCH; b += 4096){
    25fc:	953a                	add	a0,a0,a4
    25fe:	fef51de3          	bne	a0,a5,25f8 <sbrkbasic+0x40>
    exit(1);
    2602:	4505                	li	a0,1
    2604:	00003097          	auipc	ra,0x3
    2608:	0a6080e7          	jalr	166(ra) # 56aa <exit>
    printf("fork failed in sbrkbasic\n");
    260c:	00004517          	auipc	a0,0x4
    2610:	67450513          	addi	a0,a0,1652 # 6c80 <malloc+0x11a0>
    2614:	00003097          	auipc	ra,0x3
    2618:	40e080e7          	jalr	1038(ra) # 5a22 <printf>
    exit(1);
    261c:	4505                	li	a0,1
    261e:	00003097          	auipc	ra,0x3
    2622:	08c080e7          	jalr	140(ra) # 56aa <exit>
      exit(0);
    2626:	4501                	li	a0,0
    2628:	00003097          	auipc	ra,0x3
    262c:	082080e7          	jalr	130(ra) # 56aa <exit>
  wait(&xstatus);
    2630:	fbc40513          	addi	a0,s0,-68
    2634:	00003097          	auipc	ra,0x3
    2638:	07e080e7          	jalr	126(ra) # 56b2 <wait>
  if(xstatus == 1){
    263c:	fbc42703          	lw	a4,-68(s0)
    2640:	4785                	li	a5,1
    2642:	00f70e63          	beq	a4,a5,265e <sbrkbasic+0xa6>
  a = sbrk(0);
    2646:	4501                	li	a0,0
    2648:	00003097          	auipc	ra,0x3
    264c:	0ea080e7          	jalr	234(ra) # 5732 <sbrk>
    2650:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2652:	4901                	li	s2,0
    *b = 1;
    2654:	4a85                	li	s5,1
  for(i = 0; i < 5000; i++){
    2656:	6985                	lui	s3,0x1
    2658:	38898993          	addi	s3,s3,904 # 1388 <copyinstr2+0x1d6>
    265c:	a005                	j	267c <sbrkbasic+0xc4>
    printf("%s: too much memory allocated!\n", s);
    265e:	85d2                	mv	a1,s4
    2660:	00004517          	auipc	a0,0x4
    2664:	64050513          	addi	a0,a0,1600 # 6ca0 <malloc+0x11c0>
    2668:	00003097          	auipc	ra,0x3
    266c:	3ba080e7          	jalr	954(ra) # 5a22 <printf>
    exit(1);
    2670:	4505                	li	a0,1
    2672:	00003097          	auipc	ra,0x3
    2676:	038080e7          	jalr	56(ra) # 56aa <exit>
    a = b + 1;
    267a:	84be                	mv	s1,a5
    b = sbrk(1);
    267c:	4505                	li	a0,1
    267e:	00003097          	auipc	ra,0x3
    2682:	0b4080e7          	jalr	180(ra) # 5732 <sbrk>
    if(b != a){
    2686:	04951b63          	bne	a0,s1,26dc <sbrkbasic+0x124>
    *b = 1;
    268a:	01548023          	sb	s5,0(s1)
    a = b + 1;
    268e:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2692:	2905                	addiw	s2,s2,1
    2694:	ff3913e3          	bne	s2,s3,267a <sbrkbasic+0xc2>
  pid = fork();
    2698:	00003097          	auipc	ra,0x3
    269c:	00a080e7          	jalr	10(ra) # 56a2 <fork>
    26a0:	892a                	mv	s2,a0
  if(pid < 0){
    26a2:	04054d63          	bltz	a0,26fc <sbrkbasic+0x144>
  c = sbrk(1);
    26a6:	4505                	li	a0,1
    26a8:	00003097          	auipc	ra,0x3
    26ac:	08a080e7          	jalr	138(ra) # 5732 <sbrk>
  c = sbrk(1);
    26b0:	4505                	li	a0,1
    26b2:	00003097          	auipc	ra,0x3
    26b6:	080080e7          	jalr	128(ra) # 5732 <sbrk>
  if(c != a + 1){
    26ba:	0489                	addi	s1,s1,2
    26bc:	04a48e63          	beq	s1,a0,2718 <sbrkbasic+0x160>
    printf("%s: sbrk test failed post-fork\n", s);
    26c0:	85d2                	mv	a1,s4
    26c2:	00004517          	auipc	a0,0x4
    26c6:	63e50513          	addi	a0,a0,1598 # 6d00 <malloc+0x1220>
    26ca:	00003097          	auipc	ra,0x3
    26ce:	358080e7          	jalr	856(ra) # 5a22 <printf>
    exit(1);
    26d2:	4505                	li	a0,1
    26d4:	00003097          	auipc	ra,0x3
    26d8:	fd6080e7          	jalr	-42(ra) # 56aa <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    26dc:	86aa                	mv	a3,a0
    26de:	8626                	mv	a2,s1
    26e0:	85ca                	mv	a1,s2
    26e2:	00004517          	auipc	a0,0x4
    26e6:	5de50513          	addi	a0,a0,1502 # 6cc0 <malloc+0x11e0>
    26ea:	00003097          	auipc	ra,0x3
    26ee:	338080e7          	jalr	824(ra) # 5a22 <printf>
      exit(1);
    26f2:	4505                	li	a0,1
    26f4:	00003097          	auipc	ra,0x3
    26f8:	fb6080e7          	jalr	-74(ra) # 56aa <exit>
    printf("%s: sbrk test fork failed\n", s);
    26fc:	85d2                	mv	a1,s4
    26fe:	00004517          	auipc	a0,0x4
    2702:	5e250513          	addi	a0,a0,1506 # 6ce0 <malloc+0x1200>
    2706:	00003097          	auipc	ra,0x3
    270a:	31c080e7          	jalr	796(ra) # 5a22 <printf>
    exit(1);
    270e:	4505                	li	a0,1
    2710:	00003097          	auipc	ra,0x3
    2714:	f9a080e7          	jalr	-102(ra) # 56aa <exit>
  if(pid == 0)
    2718:	00091763          	bnez	s2,2726 <sbrkbasic+0x16e>
    exit(0);
    271c:	4501                	li	a0,0
    271e:	00003097          	auipc	ra,0x3
    2722:	f8c080e7          	jalr	-116(ra) # 56aa <exit>
  wait(&xstatus);
    2726:	fbc40513          	addi	a0,s0,-68
    272a:	00003097          	auipc	ra,0x3
    272e:	f88080e7          	jalr	-120(ra) # 56b2 <wait>
  exit(xstatus);
    2732:	fbc42503          	lw	a0,-68(s0)
    2736:	00003097          	auipc	ra,0x3
    273a:	f74080e7          	jalr	-140(ra) # 56aa <exit>

000000000000273e <sbrkmuch>:
{
    273e:	7179                	addi	sp,sp,-48
    2740:	f406                	sd	ra,40(sp)
    2742:	f022                	sd	s0,32(sp)
    2744:	ec26                	sd	s1,24(sp)
    2746:	e84a                	sd	s2,16(sp)
    2748:	e44e                	sd	s3,8(sp)
    274a:	e052                	sd	s4,0(sp)
    274c:	1800                	addi	s0,sp,48
    274e:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2750:	4501                	li	a0,0
    2752:	00003097          	auipc	ra,0x3
    2756:	fe0080e7          	jalr	-32(ra) # 5732 <sbrk>
    275a:	892a                	mv	s2,a0
  a = sbrk(0);
    275c:	4501                	li	a0,0
    275e:	00003097          	auipc	ra,0x3
    2762:	fd4080e7          	jalr	-44(ra) # 5732 <sbrk>
    2766:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2768:	06400537          	lui	a0,0x6400
    276c:	9d05                	subw	a0,a0,s1
    276e:	00003097          	auipc	ra,0x3
    2772:	fc4080e7          	jalr	-60(ra) # 5732 <sbrk>
  if (p != a) {
    2776:	0ca49863          	bne	s1,a0,2846 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    277a:	4501                	li	a0,0
    277c:	00003097          	auipc	ra,0x3
    2780:	fb6080e7          	jalr	-74(ra) # 5732 <sbrk>
    2784:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2786:	00a4f963          	bgeu	s1,a0,2798 <sbrkmuch+0x5a>
    *pp = 1;
    278a:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    278c:	6705                	lui	a4,0x1
    *pp = 1;
    278e:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2792:	94ba                	add	s1,s1,a4
    2794:	fef4ede3          	bltu	s1,a5,278e <sbrkmuch+0x50>
  *lastaddr = 99;
    2798:	064007b7          	lui	a5,0x6400
    279c:	06300713          	li	a4,99
    27a0:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f146f>
  a = sbrk(0);
    27a4:	4501                	li	a0,0
    27a6:	00003097          	auipc	ra,0x3
    27aa:	f8c080e7          	jalr	-116(ra) # 5732 <sbrk>
    27ae:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    27b0:	757d                	lui	a0,0xfffff
    27b2:	00003097          	auipc	ra,0x3
    27b6:	f80080e7          	jalr	-128(ra) # 5732 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    27ba:	57fd                	li	a5,-1
    27bc:	0af50363          	beq	a0,a5,2862 <sbrkmuch+0x124>
  c = sbrk(0);
    27c0:	4501                	li	a0,0
    27c2:	00003097          	auipc	ra,0x3
    27c6:	f70080e7          	jalr	-144(ra) # 5732 <sbrk>
  if(c != a - PGSIZE){
    27ca:	77fd                	lui	a5,0xfffff
    27cc:	97a6                	add	a5,a5,s1
    27ce:	0af51863          	bne	a0,a5,287e <sbrkmuch+0x140>
  a = sbrk(0);
    27d2:	4501                	li	a0,0
    27d4:	00003097          	auipc	ra,0x3
    27d8:	f5e080e7          	jalr	-162(ra) # 5732 <sbrk>
    27dc:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    27de:	6505                	lui	a0,0x1
    27e0:	00003097          	auipc	ra,0x3
    27e4:	f52080e7          	jalr	-174(ra) # 5732 <sbrk>
    27e8:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    27ea:	0aa49a63          	bne	s1,a0,289e <sbrkmuch+0x160>
    27ee:	4501                	li	a0,0
    27f0:	00003097          	auipc	ra,0x3
    27f4:	f42080e7          	jalr	-190(ra) # 5732 <sbrk>
    27f8:	6785                	lui	a5,0x1
    27fa:	97a6                	add	a5,a5,s1
    27fc:	0af51163          	bne	a0,a5,289e <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2800:	064007b7          	lui	a5,0x6400
    2804:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f146f>
    2808:	06300793          	li	a5,99
    280c:	0af70963          	beq	a4,a5,28be <sbrkmuch+0x180>
  a = sbrk(0);
    2810:	4501                	li	a0,0
    2812:	00003097          	auipc	ra,0x3
    2816:	f20080e7          	jalr	-224(ra) # 5732 <sbrk>
    281a:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    281c:	4501                	li	a0,0
    281e:	00003097          	auipc	ra,0x3
    2822:	f14080e7          	jalr	-236(ra) # 5732 <sbrk>
    2826:	40a9053b          	subw	a0,s2,a0
    282a:	00003097          	auipc	ra,0x3
    282e:	f08080e7          	jalr	-248(ra) # 5732 <sbrk>
  if(c != a){
    2832:	0aa49463          	bne	s1,a0,28da <sbrkmuch+0x19c>
}
    2836:	70a2                	ld	ra,40(sp)
    2838:	7402                	ld	s0,32(sp)
    283a:	64e2                	ld	s1,24(sp)
    283c:	6942                	ld	s2,16(sp)
    283e:	69a2                	ld	s3,8(sp)
    2840:	6a02                	ld	s4,0(sp)
    2842:	6145                	addi	sp,sp,48
    2844:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2846:	85ce                	mv	a1,s3
    2848:	00004517          	auipc	a0,0x4
    284c:	4d850513          	addi	a0,a0,1240 # 6d20 <malloc+0x1240>
    2850:	00003097          	auipc	ra,0x3
    2854:	1d2080e7          	jalr	466(ra) # 5a22 <printf>
    exit(1);
    2858:	4505                	li	a0,1
    285a:	00003097          	auipc	ra,0x3
    285e:	e50080e7          	jalr	-432(ra) # 56aa <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2862:	85ce                	mv	a1,s3
    2864:	00004517          	auipc	a0,0x4
    2868:	50450513          	addi	a0,a0,1284 # 6d68 <malloc+0x1288>
    286c:	00003097          	auipc	ra,0x3
    2870:	1b6080e7          	jalr	438(ra) # 5a22 <printf>
    exit(1);
    2874:	4505                	li	a0,1
    2876:	00003097          	auipc	ra,0x3
    287a:	e34080e7          	jalr	-460(ra) # 56aa <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    287e:	86aa                	mv	a3,a0
    2880:	8626                	mv	a2,s1
    2882:	85ce                	mv	a1,s3
    2884:	00004517          	auipc	a0,0x4
    2888:	50450513          	addi	a0,a0,1284 # 6d88 <malloc+0x12a8>
    288c:	00003097          	auipc	ra,0x3
    2890:	196080e7          	jalr	406(ra) # 5a22 <printf>
    exit(1);
    2894:	4505                	li	a0,1
    2896:	00003097          	auipc	ra,0x3
    289a:	e14080e7          	jalr	-492(ra) # 56aa <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    289e:	86d2                	mv	a3,s4
    28a0:	8626                	mv	a2,s1
    28a2:	85ce                	mv	a1,s3
    28a4:	00004517          	auipc	a0,0x4
    28a8:	52450513          	addi	a0,a0,1316 # 6dc8 <malloc+0x12e8>
    28ac:	00003097          	auipc	ra,0x3
    28b0:	176080e7          	jalr	374(ra) # 5a22 <printf>
    exit(1);
    28b4:	4505                	li	a0,1
    28b6:	00003097          	auipc	ra,0x3
    28ba:	df4080e7          	jalr	-524(ra) # 56aa <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    28be:	85ce                	mv	a1,s3
    28c0:	00004517          	auipc	a0,0x4
    28c4:	53850513          	addi	a0,a0,1336 # 6df8 <malloc+0x1318>
    28c8:	00003097          	auipc	ra,0x3
    28cc:	15a080e7          	jalr	346(ra) # 5a22 <printf>
    exit(1);
    28d0:	4505                	li	a0,1
    28d2:	00003097          	auipc	ra,0x3
    28d6:	dd8080e7          	jalr	-552(ra) # 56aa <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    28da:	86aa                	mv	a3,a0
    28dc:	8626                	mv	a2,s1
    28de:	85ce                	mv	a1,s3
    28e0:	00004517          	auipc	a0,0x4
    28e4:	55050513          	addi	a0,a0,1360 # 6e30 <malloc+0x1350>
    28e8:	00003097          	auipc	ra,0x3
    28ec:	13a080e7          	jalr	314(ra) # 5a22 <printf>
    exit(1);
    28f0:	4505                	li	a0,1
    28f2:	00003097          	auipc	ra,0x3
    28f6:	db8080e7          	jalr	-584(ra) # 56aa <exit>

00000000000028fa <sbrkarg>:
{
    28fa:	7179                	addi	sp,sp,-48
    28fc:	f406                	sd	ra,40(sp)
    28fe:	f022                	sd	s0,32(sp)
    2900:	ec26                	sd	s1,24(sp)
    2902:	e84a                	sd	s2,16(sp)
    2904:	e44e                	sd	s3,8(sp)
    2906:	1800                	addi	s0,sp,48
    2908:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    290a:	6505                	lui	a0,0x1
    290c:	00003097          	auipc	ra,0x3
    2910:	e26080e7          	jalr	-474(ra) # 5732 <sbrk>
    2914:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2916:	20100593          	li	a1,513
    291a:	00004517          	auipc	a0,0x4
    291e:	53e50513          	addi	a0,a0,1342 # 6e58 <malloc+0x1378>
    2922:	00003097          	auipc	ra,0x3
    2926:	dc8080e7          	jalr	-568(ra) # 56ea <open>
    292a:	84aa                	mv	s1,a0
  unlink("sbrk");
    292c:	00004517          	auipc	a0,0x4
    2930:	52c50513          	addi	a0,a0,1324 # 6e58 <malloc+0x1378>
    2934:	00003097          	auipc	ra,0x3
    2938:	dc6080e7          	jalr	-570(ra) # 56fa <unlink>
  if(fd < 0)  {
    293c:	0404c163          	bltz	s1,297e <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2940:	6605                	lui	a2,0x1
    2942:	85ca                	mv	a1,s2
    2944:	8526                	mv	a0,s1
    2946:	00003097          	auipc	ra,0x3
    294a:	d84080e7          	jalr	-636(ra) # 56ca <write>
    294e:	04054663          	bltz	a0,299a <sbrkarg+0xa0>
  close(fd);
    2952:	8526                	mv	a0,s1
    2954:	00003097          	auipc	ra,0x3
    2958:	d7e080e7          	jalr	-642(ra) # 56d2 <close>
  a = sbrk(PGSIZE);
    295c:	6505                	lui	a0,0x1
    295e:	00003097          	auipc	ra,0x3
    2962:	dd4080e7          	jalr	-556(ra) # 5732 <sbrk>
  if(pipe((int *) a) != 0){
    2966:	00003097          	auipc	ra,0x3
    296a:	d54080e7          	jalr	-684(ra) # 56ba <pipe>
    296e:	e521                	bnez	a0,29b6 <sbrkarg+0xbc>
}
    2970:	70a2                	ld	ra,40(sp)
    2972:	7402                	ld	s0,32(sp)
    2974:	64e2                	ld	s1,24(sp)
    2976:	6942                	ld	s2,16(sp)
    2978:	69a2                	ld	s3,8(sp)
    297a:	6145                	addi	sp,sp,48
    297c:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    297e:	85ce                	mv	a1,s3
    2980:	00004517          	auipc	a0,0x4
    2984:	4e050513          	addi	a0,a0,1248 # 6e60 <malloc+0x1380>
    2988:	00003097          	auipc	ra,0x3
    298c:	09a080e7          	jalr	154(ra) # 5a22 <printf>
    exit(1);
    2990:	4505                	li	a0,1
    2992:	00003097          	auipc	ra,0x3
    2996:	d18080e7          	jalr	-744(ra) # 56aa <exit>
    printf("%s: write sbrk failed\n", s);
    299a:	85ce                	mv	a1,s3
    299c:	00004517          	auipc	a0,0x4
    29a0:	4dc50513          	addi	a0,a0,1244 # 6e78 <malloc+0x1398>
    29a4:	00003097          	auipc	ra,0x3
    29a8:	07e080e7          	jalr	126(ra) # 5a22 <printf>
    exit(1);
    29ac:	4505                	li	a0,1
    29ae:	00003097          	auipc	ra,0x3
    29b2:	cfc080e7          	jalr	-772(ra) # 56aa <exit>
    printf("%s: pipe() failed\n", s);
    29b6:	85ce                	mv	a1,s3
    29b8:	00004517          	auipc	a0,0x4
    29bc:	ec050513          	addi	a0,a0,-320 # 6878 <malloc+0xd98>
    29c0:	00003097          	auipc	ra,0x3
    29c4:	062080e7          	jalr	98(ra) # 5a22 <printf>
    exit(1);
    29c8:	4505                	li	a0,1
    29ca:	00003097          	auipc	ra,0x3
    29ce:	ce0080e7          	jalr	-800(ra) # 56aa <exit>

00000000000029d2 <argptest>:
{
    29d2:	1101                	addi	sp,sp,-32
    29d4:	ec06                	sd	ra,24(sp)
    29d6:	e822                	sd	s0,16(sp)
    29d8:	e426                	sd	s1,8(sp)
    29da:	e04a                	sd	s2,0(sp)
    29dc:	1000                	addi	s0,sp,32
    29de:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    29e0:	4581                	li	a1,0
    29e2:	00004517          	auipc	a0,0x4
    29e6:	4ae50513          	addi	a0,a0,1198 # 6e90 <malloc+0x13b0>
    29ea:	00003097          	auipc	ra,0x3
    29ee:	d00080e7          	jalr	-768(ra) # 56ea <open>
  if (fd < 0) {
    29f2:	02054b63          	bltz	a0,2a28 <argptest+0x56>
    29f6:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    29f8:	4501                	li	a0,0
    29fa:	00003097          	auipc	ra,0x3
    29fe:	d38080e7          	jalr	-712(ra) # 5732 <sbrk>
    2a02:	567d                	li	a2,-1
    2a04:	fff50593          	addi	a1,a0,-1
    2a08:	8526                	mv	a0,s1
    2a0a:	00003097          	auipc	ra,0x3
    2a0e:	cb8080e7          	jalr	-840(ra) # 56c2 <read>
  close(fd);
    2a12:	8526                	mv	a0,s1
    2a14:	00003097          	auipc	ra,0x3
    2a18:	cbe080e7          	jalr	-834(ra) # 56d2 <close>
}
    2a1c:	60e2                	ld	ra,24(sp)
    2a1e:	6442                	ld	s0,16(sp)
    2a20:	64a2                	ld	s1,8(sp)
    2a22:	6902                	ld	s2,0(sp)
    2a24:	6105                	addi	sp,sp,32
    2a26:	8082                	ret
    printf("%s: open failed\n", s);
    2a28:	85ca                	mv	a1,s2
    2a2a:	00004517          	auipc	a0,0x4
    2a2e:	d5e50513          	addi	a0,a0,-674 # 6788 <malloc+0xca8>
    2a32:	00003097          	auipc	ra,0x3
    2a36:	ff0080e7          	jalr	-16(ra) # 5a22 <printf>
    exit(1);
    2a3a:	4505                	li	a0,1
    2a3c:	00003097          	auipc	ra,0x3
    2a40:	c6e080e7          	jalr	-914(ra) # 56aa <exit>

0000000000002a44 <sbrkbugs>:
{
    2a44:	1141                	addi	sp,sp,-16
    2a46:	e406                	sd	ra,8(sp)
    2a48:	e022                	sd	s0,0(sp)
    2a4a:	0800                	addi	s0,sp,16
  int pid = fork();
    2a4c:	00003097          	auipc	ra,0x3
    2a50:	c56080e7          	jalr	-938(ra) # 56a2 <fork>
  if(pid < 0){
    2a54:	02054263          	bltz	a0,2a78 <sbrkbugs+0x34>
  if(pid == 0){
    2a58:	ed0d                	bnez	a0,2a92 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2a5a:	00003097          	auipc	ra,0x3
    2a5e:	cd8080e7          	jalr	-808(ra) # 5732 <sbrk>
    sbrk(-sz);
    2a62:	40a0053b          	negw	a0,a0
    2a66:	00003097          	auipc	ra,0x3
    2a6a:	ccc080e7          	jalr	-820(ra) # 5732 <sbrk>
    exit(0);
    2a6e:	4501                	li	a0,0
    2a70:	00003097          	auipc	ra,0x3
    2a74:	c3a080e7          	jalr	-966(ra) # 56aa <exit>
    printf("fork failed\n");
    2a78:	00004517          	auipc	a0,0x4
    2a7c:	10050513          	addi	a0,a0,256 # 6b78 <malloc+0x1098>
    2a80:	00003097          	auipc	ra,0x3
    2a84:	fa2080e7          	jalr	-94(ra) # 5a22 <printf>
    exit(1);
    2a88:	4505                	li	a0,1
    2a8a:	00003097          	auipc	ra,0x3
    2a8e:	c20080e7          	jalr	-992(ra) # 56aa <exit>
  wait(0);
    2a92:	4501                	li	a0,0
    2a94:	00003097          	auipc	ra,0x3
    2a98:	c1e080e7          	jalr	-994(ra) # 56b2 <wait>
  pid = fork();
    2a9c:	00003097          	auipc	ra,0x3
    2aa0:	c06080e7          	jalr	-1018(ra) # 56a2 <fork>
  if(pid < 0){
    2aa4:	02054563          	bltz	a0,2ace <sbrkbugs+0x8a>
  if(pid == 0){
    2aa8:	e121                	bnez	a0,2ae8 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2aaa:	00003097          	auipc	ra,0x3
    2aae:	c88080e7          	jalr	-888(ra) # 5732 <sbrk>
    sbrk(-(sz - 3500));
    2ab2:	6785                	lui	a5,0x1
    2ab4:	dac7879b          	addiw	a5,a5,-596
    2ab8:	40a7853b          	subw	a0,a5,a0
    2abc:	00003097          	auipc	ra,0x3
    2ac0:	c76080e7          	jalr	-906(ra) # 5732 <sbrk>
    exit(0);
    2ac4:	4501                	li	a0,0
    2ac6:	00003097          	auipc	ra,0x3
    2aca:	be4080e7          	jalr	-1052(ra) # 56aa <exit>
    printf("fork failed\n");
    2ace:	00004517          	auipc	a0,0x4
    2ad2:	0aa50513          	addi	a0,a0,170 # 6b78 <malloc+0x1098>
    2ad6:	00003097          	auipc	ra,0x3
    2ada:	f4c080e7          	jalr	-180(ra) # 5a22 <printf>
    exit(1);
    2ade:	4505                	li	a0,1
    2ae0:	00003097          	auipc	ra,0x3
    2ae4:	bca080e7          	jalr	-1078(ra) # 56aa <exit>
  wait(0);
    2ae8:	4501                	li	a0,0
    2aea:	00003097          	auipc	ra,0x3
    2aee:	bc8080e7          	jalr	-1080(ra) # 56b2 <wait>
  pid = fork();
    2af2:	00003097          	auipc	ra,0x3
    2af6:	bb0080e7          	jalr	-1104(ra) # 56a2 <fork>
  if(pid < 0){
    2afa:	02054a63          	bltz	a0,2b2e <sbrkbugs+0xea>
  if(pid == 0){
    2afe:	e529                	bnez	a0,2b48 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2b00:	00003097          	auipc	ra,0x3
    2b04:	c32080e7          	jalr	-974(ra) # 5732 <sbrk>
    2b08:	67ad                	lui	a5,0xb
    2b0a:	8007879b          	addiw	a5,a5,-2048
    2b0e:	40a7853b          	subw	a0,a5,a0
    2b12:	00003097          	auipc	ra,0x3
    2b16:	c20080e7          	jalr	-992(ra) # 5732 <sbrk>
    sbrk(-10);
    2b1a:	5559                	li	a0,-10
    2b1c:	00003097          	auipc	ra,0x3
    2b20:	c16080e7          	jalr	-1002(ra) # 5732 <sbrk>
    exit(0);
    2b24:	4501                	li	a0,0
    2b26:	00003097          	auipc	ra,0x3
    2b2a:	b84080e7          	jalr	-1148(ra) # 56aa <exit>
    printf("fork failed\n");
    2b2e:	00004517          	auipc	a0,0x4
    2b32:	04a50513          	addi	a0,a0,74 # 6b78 <malloc+0x1098>
    2b36:	00003097          	auipc	ra,0x3
    2b3a:	eec080e7          	jalr	-276(ra) # 5a22 <printf>
    exit(1);
    2b3e:	4505                	li	a0,1
    2b40:	00003097          	auipc	ra,0x3
    2b44:	b6a080e7          	jalr	-1174(ra) # 56aa <exit>
  wait(0);
    2b48:	4501                	li	a0,0
    2b4a:	00003097          	auipc	ra,0x3
    2b4e:	b68080e7          	jalr	-1176(ra) # 56b2 <wait>
  exit(0);
    2b52:	4501                	li	a0,0
    2b54:	00003097          	auipc	ra,0x3
    2b58:	b56080e7          	jalr	-1194(ra) # 56aa <exit>

0000000000002b5c <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2b5c:	715d                	addi	sp,sp,-80
    2b5e:	e486                	sd	ra,72(sp)
    2b60:	e0a2                	sd	s0,64(sp)
    2b62:	fc26                	sd	s1,56(sp)
    2b64:	f84a                	sd	s2,48(sp)
    2b66:	f44e                	sd	s3,40(sp)
    2b68:	f052                	sd	s4,32(sp)
    2b6a:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2b6c:	4901                	li	s2,0
    2b6e:	49bd                	li	s3,15
    int pid = fork();
    2b70:	00003097          	auipc	ra,0x3
    2b74:	b32080e7          	jalr	-1230(ra) # 56a2 <fork>
    2b78:	84aa                	mv	s1,a0
    if(pid < 0){
    2b7a:	02054063          	bltz	a0,2b9a <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2b7e:	c91d                	beqz	a0,2bb4 <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2b80:	4501                	li	a0,0
    2b82:	00003097          	auipc	ra,0x3
    2b86:	b30080e7          	jalr	-1232(ra) # 56b2 <wait>
  for(int avail = 0; avail < 15; avail++){
    2b8a:	2905                	addiw	s2,s2,1
    2b8c:	ff3912e3          	bne	s2,s3,2b70 <execout+0x14>
    }
  }

  exit(0);
    2b90:	4501                	li	a0,0
    2b92:	00003097          	auipc	ra,0x3
    2b96:	b18080e7          	jalr	-1256(ra) # 56aa <exit>
      printf("fork failed\n");
    2b9a:	00004517          	auipc	a0,0x4
    2b9e:	fde50513          	addi	a0,a0,-34 # 6b78 <malloc+0x1098>
    2ba2:	00003097          	auipc	ra,0x3
    2ba6:	e80080e7          	jalr	-384(ra) # 5a22 <printf>
      exit(1);
    2baa:	4505                	li	a0,1
    2bac:	00003097          	auipc	ra,0x3
    2bb0:	afe080e7          	jalr	-1282(ra) # 56aa <exit>
        if(a == 0xffffffffffffffffLL)
    2bb4:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2bb6:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2bb8:	6505                	lui	a0,0x1
    2bba:	00003097          	auipc	ra,0x3
    2bbe:	b78080e7          	jalr	-1160(ra) # 5732 <sbrk>
        if(a == 0xffffffffffffffffLL)
    2bc2:	01350763          	beq	a0,s3,2bd0 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2bc6:	6785                	lui	a5,0x1
    2bc8:	953e                	add	a0,a0,a5
    2bca:	ff450fa3          	sb	s4,-1(a0) # fff <bigdir+0x9d>
      while(1){
    2bce:	b7ed                	j	2bb8 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2bd0:	01205a63          	blez	s2,2be4 <execout+0x88>
        sbrk(-4096);
    2bd4:	757d                	lui	a0,0xfffff
    2bd6:	00003097          	auipc	ra,0x3
    2bda:	b5c080e7          	jalr	-1188(ra) # 5732 <sbrk>
      for(int i = 0; i < avail; i++)
    2bde:	2485                	addiw	s1,s1,1
    2be0:	ff249ae3          	bne	s1,s2,2bd4 <execout+0x78>
      close(1);
    2be4:	4505                	li	a0,1
    2be6:	00003097          	auipc	ra,0x3
    2bea:	aec080e7          	jalr	-1300(ra) # 56d2 <close>
      char *args[] = { "echo", "x", 0 };
    2bee:	00003517          	auipc	a0,0x3
    2bf2:	34250513          	addi	a0,a0,834 # 5f30 <malloc+0x450>
    2bf6:	faa43c23          	sd	a0,-72(s0)
    2bfa:	00003797          	auipc	a5,0x3
    2bfe:	3a678793          	addi	a5,a5,934 # 5fa0 <malloc+0x4c0>
    2c02:	fcf43023          	sd	a5,-64(s0)
    2c06:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2c0a:	fb840593          	addi	a1,s0,-72
    2c0e:	00003097          	auipc	ra,0x3
    2c12:	ad4080e7          	jalr	-1324(ra) # 56e2 <exec>
      exit(0);
    2c16:	4501                	li	a0,0
    2c18:	00003097          	auipc	ra,0x3
    2c1c:	a92080e7          	jalr	-1390(ra) # 56aa <exit>

0000000000002c20 <fourteen>:
{
    2c20:	1101                	addi	sp,sp,-32
    2c22:	ec06                	sd	ra,24(sp)
    2c24:	e822                	sd	s0,16(sp)
    2c26:	e426                	sd	s1,8(sp)
    2c28:	1000                	addi	s0,sp,32
    2c2a:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2c2c:	00004517          	auipc	a0,0x4
    2c30:	43c50513          	addi	a0,a0,1084 # 7068 <malloc+0x1588>
    2c34:	00003097          	auipc	ra,0x3
    2c38:	ade080e7          	jalr	-1314(ra) # 5712 <mkdir>
    2c3c:	e165                	bnez	a0,2d1c <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2c3e:	00004517          	auipc	a0,0x4
    2c42:	28250513          	addi	a0,a0,642 # 6ec0 <malloc+0x13e0>
    2c46:	00003097          	auipc	ra,0x3
    2c4a:	acc080e7          	jalr	-1332(ra) # 5712 <mkdir>
    2c4e:	e56d                	bnez	a0,2d38 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2c50:	20000593          	li	a1,512
    2c54:	00004517          	auipc	a0,0x4
    2c58:	2c450513          	addi	a0,a0,708 # 6f18 <malloc+0x1438>
    2c5c:	00003097          	auipc	ra,0x3
    2c60:	a8e080e7          	jalr	-1394(ra) # 56ea <open>
  if(fd < 0){
    2c64:	0e054863          	bltz	a0,2d54 <fourteen+0x134>
  close(fd);
    2c68:	00003097          	auipc	ra,0x3
    2c6c:	a6a080e7          	jalr	-1430(ra) # 56d2 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2c70:	4581                	li	a1,0
    2c72:	00004517          	auipc	a0,0x4
    2c76:	31e50513          	addi	a0,a0,798 # 6f90 <malloc+0x14b0>
    2c7a:	00003097          	auipc	ra,0x3
    2c7e:	a70080e7          	jalr	-1424(ra) # 56ea <open>
  if(fd < 0){
    2c82:	0e054763          	bltz	a0,2d70 <fourteen+0x150>
  close(fd);
    2c86:	00003097          	auipc	ra,0x3
    2c8a:	a4c080e7          	jalr	-1460(ra) # 56d2 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2c8e:	00004517          	auipc	a0,0x4
    2c92:	37250513          	addi	a0,a0,882 # 7000 <malloc+0x1520>
    2c96:	00003097          	auipc	ra,0x3
    2c9a:	a7c080e7          	jalr	-1412(ra) # 5712 <mkdir>
    2c9e:	c57d                	beqz	a0,2d8c <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2ca0:	00004517          	auipc	a0,0x4
    2ca4:	3b850513          	addi	a0,a0,952 # 7058 <malloc+0x1578>
    2ca8:	00003097          	auipc	ra,0x3
    2cac:	a6a080e7          	jalr	-1430(ra) # 5712 <mkdir>
    2cb0:	cd65                	beqz	a0,2da8 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2cb2:	00004517          	auipc	a0,0x4
    2cb6:	3a650513          	addi	a0,a0,934 # 7058 <malloc+0x1578>
    2cba:	00003097          	auipc	ra,0x3
    2cbe:	a40080e7          	jalr	-1472(ra) # 56fa <unlink>
  unlink("12345678901234/12345678901234");
    2cc2:	00004517          	auipc	a0,0x4
    2cc6:	33e50513          	addi	a0,a0,830 # 7000 <malloc+0x1520>
    2cca:	00003097          	auipc	ra,0x3
    2cce:	a30080e7          	jalr	-1488(ra) # 56fa <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2cd2:	00004517          	auipc	a0,0x4
    2cd6:	2be50513          	addi	a0,a0,702 # 6f90 <malloc+0x14b0>
    2cda:	00003097          	auipc	ra,0x3
    2cde:	a20080e7          	jalr	-1504(ra) # 56fa <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2ce2:	00004517          	auipc	a0,0x4
    2ce6:	23650513          	addi	a0,a0,566 # 6f18 <malloc+0x1438>
    2cea:	00003097          	auipc	ra,0x3
    2cee:	a10080e7          	jalr	-1520(ra) # 56fa <unlink>
  unlink("12345678901234/123456789012345");
    2cf2:	00004517          	auipc	a0,0x4
    2cf6:	1ce50513          	addi	a0,a0,462 # 6ec0 <malloc+0x13e0>
    2cfa:	00003097          	auipc	ra,0x3
    2cfe:	a00080e7          	jalr	-1536(ra) # 56fa <unlink>
  unlink("12345678901234");
    2d02:	00004517          	auipc	a0,0x4
    2d06:	36650513          	addi	a0,a0,870 # 7068 <malloc+0x1588>
    2d0a:	00003097          	auipc	ra,0x3
    2d0e:	9f0080e7          	jalr	-1552(ra) # 56fa <unlink>
}
    2d12:	60e2                	ld	ra,24(sp)
    2d14:	6442                	ld	s0,16(sp)
    2d16:	64a2                	ld	s1,8(sp)
    2d18:	6105                	addi	sp,sp,32
    2d1a:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2d1c:	85a6                	mv	a1,s1
    2d1e:	00004517          	auipc	a0,0x4
    2d22:	17a50513          	addi	a0,a0,378 # 6e98 <malloc+0x13b8>
    2d26:	00003097          	auipc	ra,0x3
    2d2a:	cfc080e7          	jalr	-772(ra) # 5a22 <printf>
    exit(1);
    2d2e:	4505                	li	a0,1
    2d30:	00003097          	auipc	ra,0x3
    2d34:	97a080e7          	jalr	-1670(ra) # 56aa <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2d38:	85a6                	mv	a1,s1
    2d3a:	00004517          	auipc	a0,0x4
    2d3e:	1a650513          	addi	a0,a0,422 # 6ee0 <malloc+0x1400>
    2d42:	00003097          	auipc	ra,0x3
    2d46:	ce0080e7          	jalr	-800(ra) # 5a22 <printf>
    exit(1);
    2d4a:	4505                	li	a0,1
    2d4c:	00003097          	auipc	ra,0x3
    2d50:	95e080e7          	jalr	-1698(ra) # 56aa <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2d54:	85a6                	mv	a1,s1
    2d56:	00004517          	auipc	a0,0x4
    2d5a:	1f250513          	addi	a0,a0,498 # 6f48 <malloc+0x1468>
    2d5e:	00003097          	auipc	ra,0x3
    2d62:	cc4080e7          	jalr	-828(ra) # 5a22 <printf>
    exit(1);
    2d66:	4505                	li	a0,1
    2d68:	00003097          	auipc	ra,0x3
    2d6c:	942080e7          	jalr	-1726(ra) # 56aa <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2d70:	85a6                	mv	a1,s1
    2d72:	00004517          	auipc	a0,0x4
    2d76:	24e50513          	addi	a0,a0,590 # 6fc0 <malloc+0x14e0>
    2d7a:	00003097          	auipc	ra,0x3
    2d7e:	ca8080e7          	jalr	-856(ra) # 5a22 <printf>
    exit(1);
    2d82:	4505                	li	a0,1
    2d84:	00003097          	auipc	ra,0x3
    2d88:	926080e7          	jalr	-1754(ra) # 56aa <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2d8c:	85a6                	mv	a1,s1
    2d8e:	00004517          	auipc	a0,0x4
    2d92:	29250513          	addi	a0,a0,658 # 7020 <malloc+0x1540>
    2d96:	00003097          	auipc	ra,0x3
    2d9a:	c8c080e7          	jalr	-884(ra) # 5a22 <printf>
    exit(1);
    2d9e:	4505                	li	a0,1
    2da0:	00003097          	auipc	ra,0x3
    2da4:	90a080e7          	jalr	-1782(ra) # 56aa <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2da8:	85a6                	mv	a1,s1
    2daa:	00004517          	auipc	a0,0x4
    2dae:	2ce50513          	addi	a0,a0,718 # 7078 <malloc+0x1598>
    2db2:	00003097          	auipc	ra,0x3
    2db6:	c70080e7          	jalr	-912(ra) # 5a22 <printf>
    exit(1);
    2dba:	4505                	li	a0,1
    2dbc:	00003097          	auipc	ra,0x3
    2dc0:	8ee080e7          	jalr	-1810(ra) # 56aa <exit>

0000000000002dc4 <iputtest>:
{
    2dc4:	1101                	addi	sp,sp,-32
    2dc6:	ec06                	sd	ra,24(sp)
    2dc8:	e822                	sd	s0,16(sp)
    2dca:	e426                	sd	s1,8(sp)
    2dcc:	1000                	addi	s0,sp,32
    2dce:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2dd0:	00004517          	auipc	a0,0x4
    2dd4:	2e050513          	addi	a0,a0,736 # 70b0 <malloc+0x15d0>
    2dd8:	00003097          	auipc	ra,0x3
    2ddc:	93a080e7          	jalr	-1734(ra) # 5712 <mkdir>
    2de0:	04054563          	bltz	a0,2e2a <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2de4:	00004517          	auipc	a0,0x4
    2de8:	2cc50513          	addi	a0,a0,716 # 70b0 <malloc+0x15d0>
    2dec:	00003097          	auipc	ra,0x3
    2df0:	92e080e7          	jalr	-1746(ra) # 571a <chdir>
    2df4:	04054963          	bltz	a0,2e46 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2df8:	00004517          	auipc	a0,0x4
    2dfc:	2f850513          	addi	a0,a0,760 # 70f0 <malloc+0x1610>
    2e00:	00003097          	auipc	ra,0x3
    2e04:	8fa080e7          	jalr	-1798(ra) # 56fa <unlink>
    2e08:	04054d63          	bltz	a0,2e62 <iputtest+0x9e>
  if(chdir("/") < 0){
    2e0c:	00004517          	auipc	a0,0x4
    2e10:	31450513          	addi	a0,a0,788 # 7120 <malloc+0x1640>
    2e14:	00003097          	auipc	ra,0x3
    2e18:	906080e7          	jalr	-1786(ra) # 571a <chdir>
    2e1c:	06054163          	bltz	a0,2e7e <iputtest+0xba>
}
    2e20:	60e2                	ld	ra,24(sp)
    2e22:	6442                	ld	s0,16(sp)
    2e24:	64a2                	ld	s1,8(sp)
    2e26:	6105                	addi	sp,sp,32
    2e28:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2e2a:	85a6                	mv	a1,s1
    2e2c:	00004517          	auipc	a0,0x4
    2e30:	28c50513          	addi	a0,a0,652 # 70b8 <malloc+0x15d8>
    2e34:	00003097          	auipc	ra,0x3
    2e38:	bee080e7          	jalr	-1042(ra) # 5a22 <printf>
    exit(1);
    2e3c:	4505                	li	a0,1
    2e3e:	00003097          	auipc	ra,0x3
    2e42:	86c080e7          	jalr	-1940(ra) # 56aa <exit>
    printf("%s: chdir iputdir failed\n", s);
    2e46:	85a6                	mv	a1,s1
    2e48:	00004517          	auipc	a0,0x4
    2e4c:	28850513          	addi	a0,a0,648 # 70d0 <malloc+0x15f0>
    2e50:	00003097          	auipc	ra,0x3
    2e54:	bd2080e7          	jalr	-1070(ra) # 5a22 <printf>
    exit(1);
    2e58:	4505                	li	a0,1
    2e5a:	00003097          	auipc	ra,0x3
    2e5e:	850080e7          	jalr	-1968(ra) # 56aa <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2e62:	85a6                	mv	a1,s1
    2e64:	00004517          	auipc	a0,0x4
    2e68:	29c50513          	addi	a0,a0,668 # 7100 <malloc+0x1620>
    2e6c:	00003097          	auipc	ra,0x3
    2e70:	bb6080e7          	jalr	-1098(ra) # 5a22 <printf>
    exit(1);
    2e74:	4505                	li	a0,1
    2e76:	00003097          	auipc	ra,0x3
    2e7a:	834080e7          	jalr	-1996(ra) # 56aa <exit>
    printf("%s: chdir / failed\n", s);
    2e7e:	85a6                	mv	a1,s1
    2e80:	00004517          	auipc	a0,0x4
    2e84:	2a850513          	addi	a0,a0,680 # 7128 <malloc+0x1648>
    2e88:	00003097          	auipc	ra,0x3
    2e8c:	b9a080e7          	jalr	-1126(ra) # 5a22 <printf>
    exit(1);
    2e90:	4505                	li	a0,1
    2e92:	00003097          	auipc	ra,0x3
    2e96:	818080e7          	jalr	-2024(ra) # 56aa <exit>

0000000000002e9a <exitiputtest>:
{
    2e9a:	7179                	addi	sp,sp,-48
    2e9c:	f406                	sd	ra,40(sp)
    2e9e:	f022                	sd	s0,32(sp)
    2ea0:	ec26                	sd	s1,24(sp)
    2ea2:	1800                	addi	s0,sp,48
    2ea4:	84aa                	mv	s1,a0
  pid = fork();
    2ea6:	00002097          	auipc	ra,0x2
    2eaa:	7fc080e7          	jalr	2044(ra) # 56a2 <fork>
  if(pid < 0){
    2eae:	04054663          	bltz	a0,2efa <exitiputtest+0x60>
  if(pid == 0){
    2eb2:	ed45                	bnez	a0,2f6a <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    2eb4:	00004517          	auipc	a0,0x4
    2eb8:	1fc50513          	addi	a0,a0,508 # 70b0 <malloc+0x15d0>
    2ebc:	00003097          	auipc	ra,0x3
    2ec0:	856080e7          	jalr	-1962(ra) # 5712 <mkdir>
    2ec4:	04054963          	bltz	a0,2f16 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    2ec8:	00004517          	auipc	a0,0x4
    2ecc:	1e850513          	addi	a0,a0,488 # 70b0 <malloc+0x15d0>
    2ed0:	00003097          	auipc	ra,0x3
    2ed4:	84a080e7          	jalr	-1974(ra) # 571a <chdir>
    2ed8:	04054d63          	bltz	a0,2f32 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    2edc:	00004517          	auipc	a0,0x4
    2ee0:	21450513          	addi	a0,a0,532 # 70f0 <malloc+0x1610>
    2ee4:	00003097          	auipc	ra,0x3
    2ee8:	816080e7          	jalr	-2026(ra) # 56fa <unlink>
    2eec:	06054163          	bltz	a0,2f4e <exitiputtest+0xb4>
    exit(0);
    2ef0:	4501                	li	a0,0
    2ef2:	00002097          	auipc	ra,0x2
    2ef6:	7b8080e7          	jalr	1976(ra) # 56aa <exit>
    printf("%s: fork failed\n", s);
    2efa:	85a6                	mv	a1,s1
    2efc:	00004517          	auipc	a0,0x4
    2f00:	87450513          	addi	a0,a0,-1932 # 6770 <malloc+0xc90>
    2f04:	00003097          	auipc	ra,0x3
    2f08:	b1e080e7          	jalr	-1250(ra) # 5a22 <printf>
    exit(1);
    2f0c:	4505                	li	a0,1
    2f0e:	00002097          	auipc	ra,0x2
    2f12:	79c080e7          	jalr	1948(ra) # 56aa <exit>
      printf("%s: mkdir failed\n", s);
    2f16:	85a6                	mv	a1,s1
    2f18:	00004517          	auipc	a0,0x4
    2f1c:	1a050513          	addi	a0,a0,416 # 70b8 <malloc+0x15d8>
    2f20:	00003097          	auipc	ra,0x3
    2f24:	b02080e7          	jalr	-1278(ra) # 5a22 <printf>
      exit(1);
    2f28:	4505                	li	a0,1
    2f2a:	00002097          	auipc	ra,0x2
    2f2e:	780080e7          	jalr	1920(ra) # 56aa <exit>
      printf("%s: child chdir failed\n", s);
    2f32:	85a6                	mv	a1,s1
    2f34:	00004517          	auipc	a0,0x4
    2f38:	20c50513          	addi	a0,a0,524 # 7140 <malloc+0x1660>
    2f3c:	00003097          	auipc	ra,0x3
    2f40:	ae6080e7          	jalr	-1306(ra) # 5a22 <printf>
      exit(1);
    2f44:	4505                	li	a0,1
    2f46:	00002097          	auipc	ra,0x2
    2f4a:	764080e7          	jalr	1892(ra) # 56aa <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2f4e:	85a6                	mv	a1,s1
    2f50:	00004517          	auipc	a0,0x4
    2f54:	1b050513          	addi	a0,a0,432 # 7100 <malloc+0x1620>
    2f58:	00003097          	auipc	ra,0x3
    2f5c:	aca080e7          	jalr	-1334(ra) # 5a22 <printf>
      exit(1);
    2f60:	4505                	li	a0,1
    2f62:	00002097          	auipc	ra,0x2
    2f66:	748080e7          	jalr	1864(ra) # 56aa <exit>
  wait(&xstatus);
    2f6a:	fdc40513          	addi	a0,s0,-36
    2f6e:	00002097          	auipc	ra,0x2
    2f72:	744080e7          	jalr	1860(ra) # 56b2 <wait>
  exit(xstatus);
    2f76:	fdc42503          	lw	a0,-36(s0)
    2f7a:	00002097          	auipc	ra,0x2
    2f7e:	730080e7          	jalr	1840(ra) # 56aa <exit>

0000000000002f82 <dirtest>:
{
    2f82:	1101                	addi	sp,sp,-32
    2f84:	ec06                	sd	ra,24(sp)
    2f86:	e822                	sd	s0,16(sp)
    2f88:	e426                	sd	s1,8(sp)
    2f8a:	1000                	addi	s0,sp,32
    2f8c:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2f8e:	00004517          	auipc	a0,0x4
    2f92:	1ca50513          	addi	a0,a0,458 # 7158 <malloc+0x1678>
    2f96:	00002097          	auipc	ra,0x2
    2f9a:	77c080e7          	jalr	1916(ra) # 5712 <mkdir>
    2f9e:	04054563          	bltz	a0,2fe8 <dirtest+0x66>
  if(chdir("dir0") < 0){
    2fa2:	00004517          	auipc	a0,0x4
    2fa6:	1b650513          	addi	a0,a0,438 # 7158 <malloc+0x1678>
    2faa:	00002097          	auipc	ra,0x2
    2fae:	770080e7          	jalr	1904(ra) # 571a <chdir>
    2fb2:	04054963          	bltz	a0,3004 <dirtest+0x82>
  if(chdir("..") < 0){
    2fb6:	00004517          	auipc	a0,0x4
    2fba:	1c250513          	addi	a0,a0,450 # 7178 <malloc+0x1698>
    2fbe:	00002097          	auipc	ra,0x2
    2fc2:	75c080e7          	jalr	1884(ra) # 571a <chdir>
    2fc6:	04054d63          	bltz	a0,3020 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    2fca:	00004517          	auipc	a0,0x4
    2fce:	18e50513          	addi	a0,a0,398 # 7158 <malloc+0x1678>
    2fd2:	00002097          	auipc	ra,0x2
    2fd6:	728080e7          	jalr	1832(ra) # 56fa <unlink>
    2fda:	06054163          	bltz	a0,303c <dirtest+0xba>
}
    2fde:	60e2                	ld	ra,24(sp)
    2fe0:	6442                	ld	s0,16(sp)
    2fe2:	64a2                	ld	s1,8(sp)
    2fe4:	6105                	addi	sp,sp,32
    2fe6:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2fe8:	85a6                	mv	a1,s1
    2fea:	00004517          	auipc	a0,0x4
    2fee:	0ce50513          	addi	a0,a0,206 # 70b8 <malloc+0x15d8>
    2ff2:	00003097          	auipc	ra,0x3
    2ff6:	a30080e7          	jalr	-1488(ra) # 5a22 <printf>
    exit(1);
    2ffa:	4505                	li	a0,1
    2ffc:	00002097          	auipc	ra,0x2
    3000:	6ae080e7          	jalr	1710(ra) # 56aa <exit>
    printf("%s: chdir dir0 failed\n", s);
    3004:	85a6                	mv	a1,s1
    3006:	00004517          	auipc	a0,0x4
    300a:	15a50513          	addi	a0,a0,346 # 7160 <malloc+0x1680>
    300e:	00003097          	auipc	ra,0x3
    3012:	a14080e7          	jalr	-1516(ra) # 5a22 <printf>
    exit(1);
    3016:	4505                	li	a0,1
    3018:	00002097          	auipc	ra,0x2
    301c:	692080e7          	jalr	1682(ra) # 56aa <exit>
    printf("%s: chdir .. failed\n", s);
    3020:	85a6                	mv	a1,s1
    3022:	00004517          	auipc	a0,0x4
    3026:	15e50513          	addi	a0,a0,350 # 7180 <malloc+0x16a0>
    302a:	00003097          	auipc	ra,0x3
    302e:	9f8080e7          	jalr	-1544(ra) # 5a22 <printf>
    exit(1);
    3032:	4505                	li	a0,1
    3034:	00002097          	auipc	ra,0x2
    3038:	676080e7          	jalr	1654(ra) # 56aa <exit>
    printf("%s: unlink dir0 failed\n", s);
    303c:	85a6                	mv	a1,s1
    303e:	00004517          	auipc	a0,0x4
    3042:	15a50513          	addi	a0,a0,346 # 7198 <malloc+0x16b8>
    3046:	00003097          	auipc	ra,0x3
    304a:	9dc080e7          	jalr	-1572(ra) # 5a22 <printf>
    exit(1);
    304e:	4505                	li	a0,1
    3050:	00002097          	auipc	ra,0x2
    3054:	65a080e7          	jalr	1626(ra) # 56aa <exit>

0000000000003058 <subdir>:
{
    3058:	1101                	addi	sp,sp,-32
    305a:	ec06                	sd	ra,24(sp)
    305c:	e822                	sd	s0,16(sp)
    305e:	e426                	sd	s1,8(sp)
    3060:	e04a                	sd	s2,0(sp)
    3062:	1000                	addi	s0,sp,32
    3064:	892a                	mv	s2,a0
  unlink("ff");
    3066:	00004517          	auipc	a0,0x4
    306a:	27a50513          	addi	a0,a0,634 # 72e0 <malloc+0x1800>
    306e:	00002097          	auipc	ra,0x2
    3072:	68c080e7          	jalr	1676(ra) # 56fa <unlink>
  if(mkdir("dd") != 0){
    3076:	00004517          	auipc	a0,0x4
    307a:	13a50513          	addi	a0,a0,314 # 71b0 <malloc+0x16d0>
    307e:	00002097          	auipc	ra,0x2
    3082:	694080e7          	jalr	1684(ra) # 5712 <mkdir>
    3086:	38051663          	bnez	a0,3412 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    308a:	20200593          	li	a1,514
    308e:	00004517          	auipc	a0,0x4
    3092:	14250513          	addi	a0,a0,322 # 71d0 <malloc+0x16f0>
    3096:	00002097          	auipc	ra,0x2
    309a:	654080e7          	jalr	1620(ra) # 56ea <open>
    309e:	84aa                	mv	s1,a0
  if(fd < 0){
    30a0:	38054763          	bltz	a0,342e <subdir+0x3d6>
  write(fd, "ff", 2);
    30a4:	4609                	li	a2,2
    30a6:	00004597          	auipc	a1,0x4
    30aa:	23a58593          	addi	a1,a1,570 # 72e0 <malloc+0x1800>
    30ae:	00002097          	auipc	ra,0x2
    30b2:	61c080e7          	jalr	1564(ra) # 56ca <write>
  close(fd);
    30b6:	8526                	mv	a0,s1
    30b8:	00002097          	auipc	ra,0x2
    30bc:	61a080e7          	jalr	1562(ra) # 56d2 <close>
  if(unlink("dd") >= 0){
    30c0:	00004517          	auipc	a0,0x4
    30c4:	0f050513          	addi	a0,a0,240 # 71b0 <malloc+0x16d0>
    30c8:	00002097          	auipc	ra,0x2
    30cc:	632080e7          	jalr	1586(ra) # 56fa <unlink>
    30d0:	36055d63          	bgez	a0,344a <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    30d4:	00004517          	auipc	a0,0x4
    30d8:	15450513          	addi	a0,a0,340 # 7228 <malloc+0x1748>
    30dc:	00002097          	auipc	ra,0x2
    30e0:	636080e7          	jalr	1590(ra) # 5712 <mkdir>
    30e4:	38051163          	bnez	a0,3466 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    30e8:	20200593          	li	a1,514
    30ec:	00004517          	auipc	a0,0x4
    30f0:	16450513          	addi	a0,a0,356 # 7250 <malloc+0x1770>
    30f4:	00002097          	auipc	ra,0x2
    30f8:	5f6080e7          	jalr	1526(ra) # 56ea <open>
    30fc:	84aa                	mv	s1,a0
  if(fd < 0){
    30fe:	38054263          	bltz	a0,3482 <subdir+0x42a>
  write(fd, "FF", 2);
    3102:	4609                	li	a2,2
    3104:	00004597          	auipc	a1,0x4
    3108:	17c58593          	addi	a1,a1,380 # 7280 <malloc+0x17a0>
    310c:	00002097          	auipc	ra,0x2
    3110:	5be080e7          	jalr	1470(ra) # 56ca <write>
  close(fd);
    3114:	8526                	mv	a0,s1
    3116:	00002097          	auipc	ra,0x2
    311a:	5bc080e7          	jalr	1468(ra) # 56d2 <close>
  fd = open("dd/dd/../ff", 0);
    311e:	4581                	li	a1,0
    3120:	00004517          	auipc	a0,0x4
    3124:	16850513          	addi	a0,a0,360 # 7288 <malloc+0x17a8>
    3128:	00002097          	auipc	ra,0x2
    312c:	5c2080e7          	jalr	1474(ra) # 56ea <open>
    3130:	84aa                	mv	s1,a0
  if(fd < 0){
    3132:	36054663          	bltz	a0,349e <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3136:	660d                	lui	a2,0x3
    3138:	00009597          	auipc	a1,0x9
    313c:	a4858593          	addi	a1,a1,-1464 # bb80 <buf>
    3140:	00002097          	auipc	ra,0x2
    3144:	582080e7          	jalr	1410(ra) # 56c2 <read>
  if(cc != 2 || buf[0] != 'f'){
    3148:	4789                	li	a5,2
    314a:	36f51863          	bne	a0,a5,34ba <subdir+0x462>
    314e:	00009717          	auipc	a4,0x9
    3152:	a3274703          	lbu	a4,-1486(a4) # bb80 <buf>
    3156:	06600793          	li	a5,102
    315a:	36f71063          	bne	a4,a5,34ba <subdir+0x462>
  close(fd);
    315e:	8526                	mv	a0,s1
    3160:	00002097          	auipc	ra,0x2
    3164:	572080e7          	jalr	1394(ra) # 56d2 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3168:	00004597          	auipc	a1,0x4
    316c:	17058593          	addi	a1,a1,368 # 72d8 <malloc+0x17f8>
    3170:	00004517          	auipc	a0,0x4
    3174:	0e050513          	addi	a0,a0,224 # 7250 <malloc+0x1770>
    3178:	00002097          	auipc	ra,0x2
    317c:	592080e7          	jalr	1426(ra) # 570a <link>
    3180:	34051b63          	bnez	a0,34d6 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    3184:	00004517          	auipc	a0,0x4
    3188:	0cc50513          	addi	a0,a0,204 # 7250 <malloc+0x1770>
    318c:	00002097          	auipc	ra,0x2
    3190:	56e080e7          	jalr	1390(ra) # 56fa <unlink>
    3194:	34051f63          	bnez	a0,34f2 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3198:	4581                	li	a1,0
    319a:	00004517          	auipc	a0,0x4
    319e:	0b650513          	addi	a0,a0,182 # 7250 <malloc+0x1770>
    31a2:	00002097          	auipc	ra,0x2
    31a6:	548080e7          	jalr	1352(ra) # 56ea <open>
    31aa:	36055263          	bgez	a0,350e <subdir+0x4b6>
  if(chdir("dd") != 0){
    31ae:	00004517          	auipc	a0,0x4
    31b2:	00250513          	addi	a0,a0,2 # 71b0 <malloc+0x16d0>
    31b6:	00002097          	auipc	ra,0x2
    31ba:	564080e7          	jalr	1380(ra) # 571a <chdir>
    31be:	36051663          	bnez	a0,352a <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    31c2:	00004517          	auipc	a0,0x4
    31c6:	1ae50513          	addi	a0,a0,430 # 7370 <malloc+0x1890>
    31ca:	00002097          	auipc	ra,0x2
    31ce:	550080e7          	jalr	1360(ra) # 571a <chdir>
    31d2:	36051a63          	bnez	a0,3546 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    31d6:	00004517          	auipc	a0,0x4
    31da:	1ca50513          	addi	a0,a0,458 # 73a0 <malloc+0x18c0>
    31de:	00002097          	auipc	ra,0x2
    31e2:	53c080e7          	jalr	1340(ra) # 571a <chdir>
    31e6:	36051e63          	bnez	a0,3562 <subdir+0x50a>
  if(chdir("./..") != 0){
    31ea:	00004517          	auipc	a0,0x4
    31ee:	1e650513          	addi	a0,a0,486 # 73d0 <malloc+0x18f0>
    31f2:	00002097          	auipc	ra,0x2
    31f6:	528080e7          	jalr	1320(ra) # 571a <chdir>
    31fa:	38051263          	bnez	a0,357e <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    31fe:	4581                	li	a1,0
    3200:	00004517          	auipc	a0,0x4
    3204:	0d850513          	addi	a0,a0,216 # 72d8 <malloc+0x17f8>
    3208:	00002097          	auipc	ra,0x2
    320c:	4e2080e7          	jalr	1250(ra) # 56ea <open>
    3210:	84aa                	mv	s1,a0
  if(fd < 0){
    3212:	38054463          	bltz	a0,359a <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    3216:	660d                	lui	a2,0x3
    3218:	00009597          	auipc	a1,0x9
    321c:	96858593          	addi	a1,a1,-1688 # bb80 <buf>
    3220:	00002097          	auipc	ra,0x2
    3224:	4a2080e7          	jalr	1186(ra) # 56c2 <read>
    3228:	4789                	li	a5,2
    322a:	38f51663          	bne	a0,a5,35b6 <subdir+0x55e>
  close(fd);
    322e:	8526                	mv	a0,s1
    3230:	00002097          	auipc	ra,0x2
    3234:	4a2080e7          	jalr	1186(ra) # 56d2 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3238:	4581                	li	a1,0
    323a:	00004517          	auipc	a0,0x4
    323e:	01650513          	addi	a0,a0,22 # 7250 <malloc+0x1770>
    3242:	00002097          	auipc	ra,0x2
    3246:	4a8080e7          	jalr	1192(ra) # 56ea <open>
    324a:	38055463          	bgez	a0,35d2 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    324e:	20200593          	li	a1,514
    3252:	00004517          	auipc	a0,0x4
    3256:	20e50513          	addi	a0,a0,526 # 7460 <malloc+0x1980>
    325a:	00002097          	auipc	ra,0x2
    325e:	490080e7          	jalr	1168(ra) # 56ea <open>
    3262:	38055663          	bgez	a0,35ee <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3266:	20200593          	li	a1,514
    326a:	00004517          	auipc	a0,0x4
    326e:	22650513          	addi	a0,a0,550 # 7490 <malloc+0x19b0>
    3272:	00002097          	auipc	ra,0x2
    3276:	478080e7          	jalr	1144(ra) # 56ea <open>
    327a:	38055863          	bgez	a0,360a <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    327e:	20000593          	li	a1,512
    3282:	00004517          	auipc	a0,0x4
    3286:	f2e50513          	addi	a0,a0,-210 # 71b0 <malloc+0x16d0>
    328a:	00002097          	auipc	ra,0x2
    328e:	460080e7          	jalr	1120(ra) # 56ea <open>
    3292:	38055a63          	bgez	a0,3626 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    3296:	4589                	li	a1,2
    3298:	00004517          	auipc	a0,0x4
    329c:	f1850513          	addi	a0,a0,-232 # 71b0 <malloc+0x16d0>
    32a0:	00002097          	auipc	ra,0x2
    32a4:	44a080e7          	jalr	1098(ra) # 56ea <open>
    32a8:	38055d63          	bgez	a0,3642 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    32ac:	4585                	li	a1,1
    32ae:	00004517          	auipc	a0,0x4
    32b2:	f0250513          	addi	a0,a0,-254 # 71b0 <malloc+0x16d0>
    32b6:	00002097          	auipc	ra,0x2
    32ba:	434080e7          	jalr	1076(ra) # 56ea <open>
    32be:	3a055063          	bgez	a0,365e <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    32c2:	00004597          	auipc	a1,0x4
    32c6:	25e58593          	addi	a1,a1,606 # 7520 <malloc+0x1a40>
    32ca:	00004517          	auipc	a0,0x4
    32ce:	19650513          	addi	a0,a0,406 # 7460 <malloc+0x1980>
    32d2:	00002097          	auipc	ra,0x2
    32d6:	438080e7          	jalr	1080(ra) # 570a <link>
    32da:	3a050063          	beqz	a0,367a <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    32de:	00004597          	auipc	a1,0x4
    32e2:	24258593          	addi	a1,a1,578 # 7520 <malloc+0x1a40>
    32e6:	00004517          	auipc	a0,0x4
    32ea:	1aa50513          	addi	a0,a0,426 # 7490 <malloc+0x19b0>
    32ee:	00002097          	auipc	ra,0x2
    32f2:	41c080e7          	jalr	1052(ra) # 570a <link>
    32f6:	3a050063          	beqz	a0,3696 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    32fa:	00004597          	auipc	a1,0x4
    32fe:	fde58593          	addi	a1,a1,-34 # 72d8 <malloc+0x17f8>
    3302:	00004517          	auipc	a0,0x4
    3306:	ece50513          	addi	a0,a0,-306 # 71d0 <malloc+0x16f0>
    330a:	00002097          	auipc	ra,0x2
    330e:	400080e7          	jalr	1024(ra) # 570a <link>
    3312:	3a050063          	beqz	a0,36b2 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3316:	00004517          	auipc	a0,0x4
    331a:	14a50513          	addi	a0,a0,330 # 7460 <malloc+0x1980>
    331e:	00002097          	auipc	ra,0x2
    3322:	3f4080e7          	jalr	1012(ra) # 5712 <mkdir>
    3326:	3a050463          	beqz	a0,36ce <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    332a:	00004517          	auipc	a0,0x4
    332e:	16650513          	addi	a0,a0,358 # 7490 <malloc+0x19b0>
    3332:	00002097          	auipc	ra,0x2
    3336:	3e0080e7          	jalr	992(ra) # 5712 <mkdir>
    333a:	3a050863          	beqz	a0,36ea <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    333e:	00004517          	auipc	a0,0x4
    3342:	f9a50513          	addi	a0,a0,-102 # 72d8 <malloc+0x17f8>
    3346:	00002097          	auipc	ra,0x2
    334a:	3cc080e7          	jalr	972(ra) # 5712 <mkdir>
    334e:	3a050c63          	beqz	a0,3706 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3352:	00004517          	auipc	a0,0x4
    3356:	13e50513          	addi	a0,a0,318 # 7490 <malloc+0x19b0>
    335a:	00002097          	auipc	ra,0x2
    335e:	3a0080e7          	jalr	928(ra) # 56fa <unlink>
    3362:	3c050063          	beqz	a0,3722 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3366:	00004517          	auipc	a0,0x4
    336a:	0fa50513          	addi	a0,a0,250 # 7460 <malloc+0x1980>
    336e:	00002097          	auipc	ra,0x2
    3372:	38c080e7          	jalr	908(ra) # 56fa <unlink>
    3376:	3c050463          	beqz	a0,373e <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    337a:	00004517          	auipc	a0,0x4
    337e:	e5650513          	addi	a0,a0,-426 # 71d0 <malloc+0x16f0>
    3382:	00002097          	auipc	ra,0x2
    3386:	398080e7          	jalr	920(ra) # 571a <chdir>
    338a:	3c050863          	beqz	a0,375a <subdir+0x702>
  if(chdir("dd/xx") == 0){
    338e:	00004517          	auipc	a0,0x4
    3392:	2e250513          	addi	a0,a0,738 # 7670 <malloc+0x1b90>
    3396:	00002097          	auipc	ra,0x2
    339a:	384080e7          	jalr	900(ra) # 571a <chdir>
    339e:	3c050c63          	beqz	a0,3776 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    33a2:	00004517          	auipc	a0,0x4
    33a6:	f3650513          	addi	a0,a0,-202 # 72d8 <malloc+0x17f8>
    33aa:	00002097          	auipc	ra,0x2
    33ae:	350080e7          	jalr	848(ra) # 56fa <unlink>
    33b2:	3e051063          	bnez	a0,3792 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    33b6:	00004517          	auipc	a0,0x4
    33ba:	e1a50513          	addi	a0,a0,-486 # 71d0 <malloc+0x16f0>
    33be:	00002097          	auipc	ra,0x2
    33c2:	33c080e7          	jalr	828(ra) # 56fa <unlink>
    33c6:	3e051463          	bnez	a0,37ae <subdir+0x756>
  if(unlink("dd") == 0){
    33ca:	00004517          	auipc	a0,0x4
    33ce:	de650513          	addi	a0,a0,-538 # 71b0 <malloc+0x16d0>
    33d2:	00002097          	auipc	ra,0x2
    33d6:	328080e7          	jalr	808(ra) # 56fa <unlink>
    33da:	3e050863          	beqz	a0,37ca <subdir+0x772>
  if(unlink("dd/dd") < 0){
    33de:	00004517          	auipc	a0,0x4
    33e2:	30250513          	addi	a0,a0,770 # 76e0 <malloc+0x1c00>
    33e6:	00002097          	auipc	ra,0x2
    33ea:	314080e7          	jalr	788(ra) # 56fa <unlink>
    33ee:	3e054c63          	bltz	a0,37e6 <subdir+0x78e>
  if(unlink("dd") < 0){
    33f2:	00004517          	auipc	a0,0x4
    33f6:	dbe50513          	addi	a0,a0,-578 # 71b0 <malloc+0x16d0>
    33fa:	00002097          	auipc	ra,0x2
    33fe:	300080e7          	jalr	768(ra) # 56fa <unlink>
    3402:	40054063          	bltz	a0,3802 <subdir+0x7aa>
}
    3406:	60e2                	ld	ra,24(sp)
    3408:	6442                	ld	s0,16(sp)
    340a:	64a2                	ld	s1,8(sp)
    340c:	6902                	ld	s2,0(sp)
    340e:	6105                	addi	sp,sp,32
    3410:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3412:	85ca                	mv	a1,s2
    3414:	00004517          	auipc	a0,0x4
    3418:	da450513          	addi	a0,a0,-604 # 71b8 <malloc+0x16d8>
    341c:	00002097          	auipc	ra,0x2
    3420:	606080e7          	jalr	1542(ra) # 5a22 <printf>
    exit(1);
    3424:	4505                	li	a0,1
    3426:	00002097          	auipc	ra,0x2
    342a:	284080e7          	jalr	644(ra) # 56aa <exit>
    printf("%s: create dd/ff failed\n", s);
    342e:	85ca                	mv	a1,s2
    3430:	00004517          	auipc	a0,0x4
    3434:	da850513          	addi	a0,a0,-600 # 71d8 <malloc+0x16f8>
    3438:	00002097          	auipc	ra,0x2
    343c:	5ea080e7          	jalr	1514(ra) # 5a22 <printf>
    exit(1);
    3440:	4505                	li	a0,1
    3442:	00002097          	auipc	ra,0x2
    3446:	268080e7          	jalr	616(ra) # 56aa <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    344a:	85ca                	mv	a1,s2
    344c:	00004517          	auipc	a0,0x4
    3450:	dac50513          	addi	a0,a0,-596 # 71f8 <malloc+0x1718>
    3454:	00002097          	auipc	ra,0x2
    3458:	5ce080e7          	jalr	1486(ra) # 5a22 <printf>
    exit(1);
    345c:	4505                	li	a0,1
    345e:	00002097          	auipc	ra,0x2
    3462:	24c080e7          	jalr	588(ra) # 56aa <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3466:	85ca                	mv	a1,s2
    3468:	00004517          	auipc	a0,0x4
    346c:	dc850513          	addi	a0,a0,-568 # 7230 <malloc+0x1750>
    3470:	00002097          	auipc	ra,0x2
    3474:	5b2080e7          	jalr	1458(ra) # 5a22 <printf>
    exit(1);
    3478:	4505                	li	a0,1
    347a:	00002097          	auipc	ra,0x2
    347e:	230080e7          	jalr	560(ra) # 56aa <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3482:	85ca                	mv	a1,s2
    3484:	00004517          	auipc	a0,0x4
    3488:	ddc50513          	addi	a0,a0,-548 # 7260 <malloc+0x1780>
    348c:	00002097          	auipc	ra,0x2
    3490:	596080e7          	jalr	1430(ra) # 5a22 <printf>
    exit(1);
    3494:	4505                	li	a0,1
    3496:	00002097          	auipc	ra,0x2
    349a:	214080e7          	jalr	532(ra) # 56aa <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    349e:	85ca                	mv	a1,s2
    34a0:	00004517          	auipc	a0,0x4
    34a4:	df850513          	addi	a0,a0,-520 # 7298 <malloc+0x17b8>
    34a8:	00002097          	auipc	ra,0x2
    34ac:	57a080e7          	jalr	1402(ra) # 5a22 <printf>
    exit(1);
    34b0:	4505                	li	a0,1
    34b2:	00002097          	auipc	ra,0x2
    34b6:	1f8080e7          	jalr	504(ra) # 56aa <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    34ba:	85ca                	mv	a1,s2
    34bc:	00004517          	auipc	a0,0x4
    34c0:	dfc50513          	addi	a0,a0,-516 # 72b8 <malloc+0x17d8>
    34c4:	00002097          	auipc	ra,0x2
    34c8:	55e080e7          	jalr	1374(ra) # 5a22 <printf>
    exit(1);
    34cc:	4505                	li	a0,1
    34ce:	00002097          	auipc	ra,0x2
    34d2:	1dc080e7          	jalr	476(ra) # 56aa <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    34d6:	85ca                	mv	a1,s2
    34d8:	00004517          	auipc	a0,0x4
    34dc:	e1050513          	addi	a0,a0,-496 # 72e8 <malloc+0x1808>
    34e0:	00002097          	auipc	ra,0x2
    34e4:	542080e7          	jalr	1346(ra) # 5a22 <printf>
    exit(1);
    34e8:	4505                	li	a0,1
    34ea:	00002097          	auipc	ra,0x2
    34ee:	1c0080e7          	jalr	448(ra) # 56aa <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    34f2:	85ca                	mv	a1,s2
    34f4:	00004517          	auipc	a0,0x4
    34f8:	e1c50513          	addi	a0,a0,-484 # 7310 <malloc+0x1830>
    34fc:	00002097          	auipc	ra,0x2
    3500:	526080e7          	jalr	1318(ra) # 5a22 <printf>
    exit(1);
    3504:	4505                	li	a0,1
    3506:	00002097          	auipc	ra,0x2
    350a:	1a4080e7          	jalr	420(ra) # 56aa <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    350e:	85ca                	mv	a1,s2
    3510:	00004517          	auipc	a0,0x4
    3514:	e2050513          	addi	a0,a0,-480 # 7330 <malloc+0x1850>
    3518:	00002097          	auipc	ra,0x2
    351c:	50a080e7          	jalr	1290(ra) # 5a22 <printf>
    exit(1);
    3520:	4505                	li	a0,1
    3522:	00002097          	auipc	ra,0x2
    3526:	188080e7          	jalr	392(ra) # 56aa <exit>
    printf("%s: chdir dd failed\n", s);
    352a:	85ca                	mv	a1,s2
    352c:	00004517          	auipc	a0,0x4
    3530:	e2c50513          	addi	a0,a0,-468 # 7358 <malloc+0x1878>
    3534:	00002097          	auipc	ra,0x2
    3538:	4ee080e7          	jalr	1262(ra) # 5a22 <printf>
    exit(1);
    353c:	4505                	li	a0,1
    353e:	00002097          	auipc	ra,0x2
    3542:	16c080e7          	jalr	364(ra) # 56aa <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3546:	85ca                	mv	a1,s2
    3548:	00004517          	auipc	a0,0x4
    354c:	e3850513          	addi	a0,a0,-456 # 7380 <malloc+0x18a0>
    3550:	00002097          	auipc	ra,0x2
    3554:	4d2080e7          	jalr	1234(ra) # 5a22 <printf>
    exit(1);
    3558:	4505                	li	a0,1
    355a:	00002097          	auipc	ra,0x2
    355e:	150080e7          	jalr	336(ra) # 56aa <exit>
    printf("chdir dd/../../dd failed\n", s);
    3562:	85ca                	mv	a1,s2
    3564:	00004517          	auipc	a0,0x4
    3568:	e4c50513          	addi	a0,a0,-436 # 73b0 <malloc+0x18d0>
    356c:	00002097          	auipc	ra,0x2
    3570:	4b6080e7          	jalr	1206(ra) # 5a22 <printf>
    exit(1);
    3574:	4505                	li	a0,1
    3576:	00002097          	auipc	ra,0x2
    357a:	134080e7          	jalr	308(ra) # 56aa <exit>
    printf("%s: chdir ./.. failed\n", s);
    357e:	85ca                	mv	a1,s2
    3580:	00004517          	auipc	a0,0x4
    3584:	e5850513          	addi	a0,a0,-424 # 73d8 <malloc+0x18f8>
    3588:	00002097          	auipc	ra,0x2
    358c:	49a080e7          	jalr	1178(ra) # 5a22 <printf>
    exit(1);
    3590:	4505                	li	a0,1
    3592:	00002097          	auipc	ra,0x2
    3596:	118080e7          	jalr	280(ra) # 56aa <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    359a:	85ca                	mv	a1,s2
    359c:	00004517          	auipc	a0,0x4
    35a0:	e5450513          	addi	a0,a0,-428 # 73f0 <malloc+0x1910>
    35a4:	00002097          	auipc	ra,0x2
    35a8:	47e080e7          	jalr	1150(ra) # 5a22 <printf>
    exit(1);
    35ac:	4505                	li	a0,1
    35ae:	00002097          	auipc	ra,0x2
    35b2:	0fc080e7          	jalr	252(ra) # 56aa <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    35b6:	85ca                	mv	a1,s2
    35b8:	00004517          	auipc	a0,0x4
    35bc:	e5850513          	addi	a0,a0,-424 # 7410 <malloc+0x1930>
    35c0:	00002097          	auipc	ra,0x2
    35c4:	462080e7          	jalr	1122(ra) # 5a22 <printf>
    exit(1);
    35c8:	4505                	li	a0,1
    35ca:	00002097          	auipc	ra,0x2
    35ce:	0e0080e7          	jalr	224(ra) # 56aa <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    35d2:	85ca                	mv	a1,s2
    35d4:	00004517          	auipc	a0,0x4
    35d8:	e5c50513          	addi	a0,a0,-420 # 7430 <malloc+0x1950>
    35dc:	00002097          	auipc	ra,0x2
    35e0:	446080e7          	jalr	1094(ra) # 5a22 <printf>
    exit(1);
    35e4:	4505                	li	a0,1
    35e6:	00002097          	auipc	ra,0x2
    35ea:	0c4080e7          	jalr	196(ra) # 56aa <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    35ee:	85ca                	mv	a1,s2
    35f0:	00004517          	auipc	a0,0x4
    35f4:	e8050513          	addi	a0,a0,-384 # 7470 <malloc+0x1990>
    35f8:	00002097          	auipc	ra,0x2
    35fc:	42a080e7          	jalr	1066(ra) # 5a22 <printf>
    exit(1);
    3600:	4505                	li	a0,1
    3602:	00002097          	auipc	ra,0x2
    3606:	0a8080e7          	jalr	168(ra) # 56aa <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    360a:	85ca                	mv	a1,s2
    360c:	00004517          	auipc	a0,0x4
    3610:	e9450513          	addi	a0,a0,-364 # 74a0 <malloc+0x19c0>
    3614:	00002097          	auipc	ra,0x2
    3618:	40e080e7          	jalr	1038(ra) # 5a22 <printf>
    exit(1);
    361c:	4505                	li	a0,1
    361e:	00002097          	auipc	ra,0x2
    3622:	08c080e7          	jalr	140(ra) # 56aa <exit>
    printf("%s: create dd succeeded!\n", s);
    3626:	85ca                	mv	a1,s2
    3628:	00004517          	auipc	a0,0x4
    362c:	e9850513          	addi	a0,a0,-360 # 74c0 <malloc+0x19e0>
    3630:	00002097          	auipc	ra,0x2
    3634:	3f2080e7          	jalr	1010(ra) # 5a22 <printf>
    exit(1);
    3638:	4505                	li	a0,1
    363a:	00002097          	auipc	ra,0x2
    363e:	070080e7          	jalr	112(ra) # 56aa <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3642:	85ca                	mv	a1,s2
    3644:	00004517          	auipc	a0,0x4
    3648:	e9c50513          	addi	a0,a0,-356 # 74e0 <malloc+0x1a00>
    364c:	00002097          	auipc	ra,0x2
    3650:	3d6080e7          	jalr	982(ra) # 5a22 <printf>
    exit(1);
    3654:	4505                	li	a0,1
    3656:	00002097          	auipc	ra,0x2
    365a:	054080e7          	jalr	84(ra) # 56aa <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    365e:	85ca                	mv	a1,s2
    3660:	00004517          	auipc	a0,0x4
    3664:	ea050513          	addi	a0,a0,-352 # 7500 <malloc+0x1a20>
    3668:	00002097          	auipc	ra,0x2
    366c:	3ba080e7          	jalr	954(ra) # 5a22 <printf>
    exit(1);
    3670:	4505                	li	a0,1
    3672:	00002097          	auipc	ra,0x2
    3676:	038080e7          	jalr	56(ra) # 56aa <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    367a:	85ca                	mv	a1,s2
    367c:	00004517          	auipc	a0,0x4
    3680:	eb450513          	addi	a0,a0,-332 # 7530 <malloc+0x1a50>
    3684:	00002097          	auipc	ra,0x2
    3688:	39e080e7          	jalr	926(ra) # 5a22 <printf>
    exit(1);
    368c:	4505                	li	a0,1
    368e:	00002097          	auipc	ra,0x2
    3692:	01c080e7          	jalr	28(ra) # 56aa <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3696:	85ca                	mv	a1,s2
    3698:	00004517          	auipc	a0,0x4
    369c:	ec050513          	addi	a0,a0,-320 # 7558 <malloc+0x1a78>
    36a0:	00002097          	auipc	ra,0x2
    36a4:	382080e7          	jalr	898(ra) # 5a22 <printf>
    exit(1);
    36a8:	4505                	li	a0,1
    36aa:	00002097          	auipc	ra,0x2
    36ae:	000080e7          	jalr	ra # 56aa <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    36b2:	85ca                	mv	a1,s2
    36b4:	00004517          	auipc	a0,0x4
    36b8:	ecc50513          	addi	a0,a0,-308 # 7580 <malloc+0x1aa0>
    36bc:	00002097          	auipc	ra,0x2
    36c0:	366080e7          	jalr	870(ra) # 5a22 <printf>
    exit(1);
    36c4:	4505                	li	a0,1
    36c6:	00002097          	auipc	ra,0x2
    36ca:	fe4080e7          	jalr	-28(ra) # 56aa <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    36ce:	85ca                	mv	a1,s2
    36d0:	00004517          	auipc	a0,0x4
    36d4:	ed850513          	addi	a0,a0,-296 # 75a8 <malloc+0x1ac8>
    36d8:	00002097          	auipc	ra,0x2
    36dc:	34a080e7          	jalr	842(ra) # 5a22 <printf>
    exit(1);
    36e0:	4505                	li	a0,1
    36e2:	00002097          	auipc	ra,0x2
    36e6:	fc8080e7          	jalr	-56(ra) # 56aa <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    36ea:	85ca                	mv	a1,s2
    36ec:	00004517          	auipc	a0,0x4
    36f0:	edc50513          	addi	a0,a0,-292 # 75c8 <malloc+0x1ae8>
    36f4:	00002097          	auipc	ra,0x2
    36f8:	32e080e7          	jalr	814(ra) # 5a22 <printf>
    exit(1);
    36fc:	4505                	li	a0,1
    36fe:	00002097          	auipc	ra,0x2
    3702:	fac080e7          	jalr	-84(ra) # 56aa <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3706:	85ca                	mv	a1,s2
    3708:	00004517          	auipc	a0,0x4
    370c:	ee050513          	addi	a0,a0,-288 # 75e8 <malloc+0x1b08>
    3710:	00002097          	auipc	ra,0x2
    3714:	312080e7          	jalr	786(ra) # 5a22 <printf>
    exit(1);
    3718:	4505                	li	a0,1
    371a:	00002097          	auipc	ra,0x2
    371e:	f90080e7          	jalr	-112(ra) # 56aa <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3722:	85ca                	mv	a1,s2
    3724:	00004517          	auipc	a0,0x4
    3728:	eec50513          	addi	a0,a0,-276 # 7610 <malloc+0x1b30>
    372c:	00002097          	auipc	ra,0x2
    3730:	2f6080e7          	jalr	758(ra) # 5a22 <printf>
    exit(1);
    3734:	4505                	li	a0,1
    3736:	00002097          	auipc	ra,0x2
    373a:	f74080e7          	jalr	-140(ra) # 56aa <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    373e:	85ca                	mv	a1,s2
    3740:	00004517          	auipc	a0,0x4
    3744:	ef050513          	addi	a0,a0,-272 # 7630 <malloc+0x1b50>
    3748:	00002097          	auipc	ra,0x2
    374c:	2da080e7          	jalr	730(ra) # 5a22 <printf>
    exit(1);
    3750:	4505                	li	a0,1
    3752:	00002097          	auipc	ra,0x2
    3756:	f58080e7          	jalr	-168(ra) # 56aa <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    375a:	85ca                	mv	a1,s2
    375c:	00004517          	auipc	a0,0x4
    3760:	ef450513          	addi	a0,a0,-268 # 7650 <malloc+0x1b70>
    3764:	00002097          	auipc	ra,0x2
    3768:	2be080e7          	jalr	702(ra) # 5a22 <printf>
    exit(1);
    376c:	4505                	li	a0,1
    376e:	00002097          	auipc	ra,0x2
    3772:	f3c080e7          	jalr	-196(ra) # 56aa <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3776:	85ca                	mv	a1,s2
    3778:	00004517          	auipc	a0,0x4
    377c:	f0050513          	addi	a0,a0,-256 # 7678 <malloc+0x1b98>
    3780:	00002097          	auipc	ra,0x2
    3784:	2a2080e7          	jalr	674(ra) # 5a22 <printf>
    exit(1);
    3788:	4505                	li	a0,1
    378a:	00002097          	auipc	ra,0x2
    378e:	f20080e7          	jalr	-224(ra) # 56aa <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3792:	85ca                	mv	a1,s2
    3794:	00004517          	auipc	a0,0x4
    3798:	b7c50513          	addi	a0,a0,-1156 # 7310 <malloc+0x1830>
    379c:	00002097          	auipc	ra,0x2
    37a0:	286080e7          	jalr	646(ra) # 5a22 <printf>
    exit(1);
    37a4:	4505                	li	a0,1
    37a6:	00002097          	auipc	ra,0x2
    37aa:	f04080e7          	jalr	-252(ra) # 56aa <exit>
    printf("%s: unlink dd/ff failed\n", s);
    37ae:	85ca                	mv	a1,s2
    37b0:	00004517          	auipc	a0,0x4
    37b4:	ee850513          	addi	a0,a0,-280 # 7698 <malloc+0x1bb8>
    37b8:	00002097          	auipc	ra,0x2
    37bc:	26a080e7          	jalr	618(ra) # 5a22 <printf>
    exit(1);
    37c0:	4505                	li	a0,1
    37c2:	00002097          	auipc	ra,0x2
    37c6:	ee8080e7          	jalr	-280(ra) # 56aa <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    37ca:	85ca                	mv	a1,s2
    37cc:	00004517          	auipc	a0,0x4
    37d0:	eec50513          	addi	a0,a0,-276 # 76b8 <malloc+0x1bd8>
    37d4:	00002097          	auipc	ra,0x2
    37d8:	24e080e7          	jalr	590(ra) # 5a22 <printf>
    exit(1);
    37dc:	4505                	li	a0,1
    37de:	00002097          	auipc	ra,0x2
    37e2:	ecc080e7          	jalr	-308(ra) # 56aa <exit>
    printf("%s: unlink dd/dd failed\n", s);
    37e6:	85ca                	mv	a1,s2
    37e8:	00004517          	auipc	a0,0x4
    37ec:	f0050513          	addi	a0,a0,-256 # 76e8 <malloc+0x1c08>
    37f0:	00002097          	auipc	ra,0x2
    37f4:	232080e7          	jalr	562(ra) # 5a22 <printf>
    exit(1);
    37f8:	4505                	li	a0,1
    37fa:	00002097          	auipc	ra,0x2
    37fe:	eb0080e7          	jalr	-336(ra) # 56aa <exit>
    printf("%s: unlink dd failed\n", s);
    3802:	85ca                	mv	a1,s2
    3804:	00004517          	auipc	a0,0x4
    3808:	f0450513          	addi	a0,a0,-252 # 7708 <malloc+0x1c28>
    380c:	00002097          	auipc	ra,0x2
    3810:	216080e7          	jalr	534(ra) # 5a22 <printf>
    exit(1);
    3814:	4505                	li	a0,1
    3816:	00002097          	auipc	ra,0x2
    381a:	e94080e7          	jalr	-364(ra) # 56aa <exit>

000000000000381e <rmdot>:
{
    381e:	1101                	addi	sp,sp,-32
    3820:	ec06                	sd	ra,24(sp)
    3822:	e822                	sd	s0,16(sp)
    3824:	e426                	sd	s1,8(sp)
    3826:	1000                	addi	s0,sp,32
    3828:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    382a:	00004517          	auipc	a0,0x4
    382e:	ef650513          	addi	a0,a0,-266 # 7720 <malloc+0x1c40>
    3832:	00002097          	auipc	ra,0x2
    3836:	ee0080e7          	jalr	-288(ra) # 5712 <mkdir>
    383a:	e549                	bnez	a0,38c4 <rmdot+0xa6>
  if(chdir("dots") != 0){
    383c:	00004517          	auipc	a0,0x4
    3840:	ee450513          	addi	a0,a0,-284 # 7720 <malloc+0x1c40>
    3844:	00002097          	auipc	ra,0x2
    3848:	ed6080e7          	jalr	-298(ra) # 571a <chdir>
    384c:	e951                	bnez	a0,38e0 <rmdot+0xc2>
  if(unlink(".") == 0){
    384e:	00003517          	auipc	a0,0x3
    3852:	d8250513          	addi	a0,a0,-638 # 65d0 <malloc+0xaf0>
    3856:	00002097          	auipc	ra,0x2
    385a:	ea4080e7          	jalr	-348(ra) # 56fa <unlink>
    385e:	cd59                	beqz	a0,38fc <rmdot+0xde>
  if(unlink("..") == 0){
    3860:	00004517          	auipc	a0,0x4
    3864:	91850513          	addi	a0,a0,-1768 # 7178 <malloc+0x1698>
    3868:	00002097          	auipc	ra,0x2
    386c:	e92080e7          	jalr	-366(ra) # 56fa <unlink>
    3870:	c545                	beqz	a0,3918 <rmdot+0xfa>
  if(chdir("/") != 0){
    3872:	00004517          	auipc	a0,0x4
    3876:	8ae50513          	addi	a0,a0,-1874 # 7120 <malloc+0x1640>
    387a:	00002097          	auipc	ra,0x2
    387e:	ea0080e7          	jalr	-352(ra) # 571a <chdir>
    3882:	e94d                	bnez	a0,3934 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3884:	00004517          	auipc	a0,0x4
    3888:	f0450513          	addi	a0,a0,-252 # 7788 <malloc+0x1ca8>
    388c:	00002097          	auipc	ra,0x2
    3890:	e6e080e7          	jalr	-402(ra) # 56fa <unlink>
    3894:	cd55                	beqz	a0,3950 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3896:	00004517          	auipc	a0,0x4
    389a:	f1a50513          	addi	a0,a0,-230 # 77b0 <malloc+0x1cd0>
    389e:	00002097          	auipc	ra,0x2
    38a2:	e5c080e7          	jalr	-420(ra) # 56fa <unlink>
    38a6:	c179                	beqz	a0,396c <rmdot+0x14e>
  if(unlink("dots") != 0){
    38a8:	00004517          	auipc	a0,0x4
    38ac:	e7850513          	addi	a0,a0,-392 # 7720 <malloc+0x1c40>
    38b0:	00002097          	auipc	ra,0x2
    38b4:	e4a080e7          	jalr	-438(ra) # 56fa <unlink>
    38b8:	e961                	bnez	a0,3988 <rmdot+0x16a>
}
    38ba:	60e2                	ld	ra,24(sp)
    38bc:	6442                	ld	s0,16(sp)
    38be:	64a2                	ld	s1,8(sp)
    38c0:	6105                	addi	sp,sp,32
    38c2:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    38c4:	85a6                	mv	a1,s1
    38c6:	00004517          	auipc	a0,0x4
    38ca:	e6250513          	addi	a0,a0,-414 # 7728 <malloc+0x1c48>
    38ce:	00002097          	auipc	ra,0x2
    38d2:	154080e7          	jalr	340(ra) # 5a22 <printf>
    exit(1);
    38d6:	4505                	li	a0,1
    38d8:	00002097          	auipc	ra,0x2
    38dc:	dd2080e7          	jalr	-558(ra) # 56aa <exit>
    printf("%s: chdir dots failed\n", s);
    38e0:	85a6                	mv	a1,s1
    38e2:	00004517          	auipc	a0,0x4
    38e6:	e5e50513          	addi	a0,a0,-418 # 7740 <malloc+0x1c60>
    38ea:	00002097          	auipc	ra,0x2
    38ee:	138080e7          	jalr	312(ra) # 5a22 <printf>
    exit(1);
    38f2:	4505                	li	a0,1
    38f4:	00002097          	auipc	ra,0x2
    38f8:	db6080e7          	jalr	-586(ra) # 56aa <exit>
    printf("%s: rm . worked!\n", s);
    38fc:	85a6                	mv	a1,s1
    38fe:	00004517          	auipc	a0,0x4
    3902:	e5a50513          	addi	a0,a0,-422 # 7758 <malloc+0x1c78>
    3906:	00002097          	auipc	ra,0x2
    390a:	11c080e7          	jalr	284(ra) # 5a22 <printf>
    exit(1);
    390e:	4505                	li	a0,1
    3910:	00002097          	auipc	ra,0x2
    3914:	d9a080e7          	jalr	-614(ra) # 56aa <exit>
    printf("%s: rm .. worked!\n", s);
    3918:	85a6                	mv	a1,s1
    391a:	00004517          	auipc	a0,0x4
    391e:	e5650513          	addi	a0,a0,-426 # 7770 <malloc+0x1c90>
    3922:	00002097          	auipc	ra,0x2
    3926:	100080e7          	jalr	256(ra) # 5a22 <printf>
    exit(1);
    392a:	4505                	li	a0,1
    392c:	00002097          	auipc	ra,0x2
    3930:	d7e080e7          	jalr	-642(ra) # 56aa <exit>
    printf("%s: chdir / failed\n", s);
    3934:	85a6                	mv	a1,s1
    3936:	00003517          	auipc	a0,0x3
    393a:	7f250513          	addi	a0,a0,2034 # 7128 <malloc+0x1648>
    393e:	00002097          	auipc	ra,0x2
    3942:	0e4080e7          	jalr	228(ra) # 5a22 <printf>
    exit(1);
    3946:	4505                	li	a0,1
    3948:	00002097          	auipc	ra,0x2
    394c:	d62080e7          	jalr	-670(ra) # 56aa <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3950:	85a6                	mv	a1,s1
    3952:	00004517          	auipc	a0,0x4
    3956:	e3e50513          	addi	a0,a0,-450 # 7790 <malloc+0x1cb0>
    395a:	00002097          	auipc	ra,0x2
    395e:	0c8080e7          	jalr	200(ra) # 5a22 <printf>
    exit(1);
    3962:	4505                	li	a0,1
    3964:	00002097          	auipc	ra,0x2
    3968:	d46080e7          	jalr	-698(ra) # 56aa <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    396c:	85a6                	mv	a1,s1
    396e:	00004517          	auipc	a0,0x4
    3972:	e4a50513          	addi	a0,a0,-438 # 77b8 <malloc+0x1cd8>
    3976:	00002097          	auipc	ra,0x2
    397a:	0ac080e7          	jalr	172(ra) # 5a22 <printf>
    exit(1);
    397e:	4505                	li	a0,1
    3980:	00002097          	auipc	ra,0x2
    3984:	d2a080e7          	jalr	-726(ra) # 56aa <exit>
    printf("%s: unlink dots failed!\n", s);
    3988:	85a6                	mv	a1,s1
    398a:	00004517          	auipc	a0,0x4
    398e:	e4e50513          	addi	a0,a0,-434 # 77d8 <malloc+0x1cf8>
    3992:	00002097          	auipc	ra,0x2
    3996:	090080e7          	jalr	144(ra) # 5a22 <printf>
    exit(1);
    399a:	4505                	li	a0,1
    399c:	00002097          	auipc	ra,0x2
    39a0:	d0e080e7          	jalr	-754(ra) # 56aa <exit>

00000000000039a4 <dirfile>:
{
    39a4:	1101                	addi	sp,sp,-32
    39a6:	ec06                	sd	ra,24(sp)
    39a8:	e822                	sd	s0,16(sp)
    39aa:	e426                	sd	s1,8(sp)
    39ac:	e04a                	sd	s2,0(sp)
    39ae:	1000                	addi	s0,sp,32
    39b0:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    39b2:	20000593          	li	a1,512
    39b6:	00002517          	auipc	a0,0x2
    39ba:	51a50513          	addi	a0,a0,1306 # 5ed0 <malloc+0x3f0>
    39be:	00002097          	auipc	ra,0x2
    39c2:	d2c080e7          	jalr	-724(ra) # 56ea <open>
  if(fd < 0){
    39c6:	0e054d63          	bltz	a0,3ac0 <dirfile+0x11c>
  close(fd);
    39ca:	00002097          	auipc	ra,0x2
    39ce:	d08080e7          	jalr	-760(ra) # 56d2 <close>
  if(chdir("dirfile") == 0){
    39d2:	00002517          	auipc	a0,0x2
    39d6:	4fe50513          	addi	a0,a0,1278 # 5ed0 <malloc+0x3f0>
    39da:	00002097          	auipc	ra,0x2
    39de:	d40080e7          	jalr	-704(ra) # 571a <chdir>
    39e2:	cd6d                	beqz	a0,3adc <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    39e4:	4581                	li	a1,0
    39e6:	00004517          	auipc	a0,0x4
    39ea:	e5250513          	addi	a0,a0,-430 # 7838 <malloc+0x1d58>
    39ee:	00002097          	auipc	ra,0x2
    39f2:	cfc080e7          	jalr	-772(ra) # 56ea <open>
  if(fd >= 0){
    39f6:	10055163          	bgez	a0,3af8 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    39fa:	20000593          	li	a1,512
    39fe:	00004517          	auipc	a0,0x4
    3a02:	e3a50513          	addi	a0,a0,-454 # 7838 <malloc+0x1d58>
    3a06:	00002097          	auipc	ra,0x2
    3a0a:	ce4080e7          	jalr	-796(ra) # 56ea <open>
  if(fd >= 0){
    3a0e:	10055363          	bgez	a0,3b14 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3a12:	00004517          	auipc	a0,0x4
    3a16:	e2650513          	addi	a0,a0,-474 # 7838 <malloc+0x1d58>
    3a1a:	00002097          	auipc	ra,0x2
    3a1e:	cf8080e7          	jalr	-776(ra) # 5712 <mkdir>
    3a22:	10050763          	beqz	a0,3b30 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3a26:	00004517          	auipc	a0,0x4
    3a2a:	e1250513          	addi	a0,a0,-494 # 7838 <malloc+0x1d58>
    3a2e:	00002097          	auipc	ra,0x2
    3a32:	ccc080e7          	jalr	-820(ra) # 56fa <unlink>
    3a36:	10050b63          	beqz	a0,3b4c <dirfile+0x1a8>
  if(link("README.md", "dirfile/xx") == 0){
    3a3a:	00004597          	auipc	a1,0x4
    3a3e:	dfe58593          	addi	a1,a1,-514 # 7838 <malloc+0x1d58>
    3a42:	00002517          	auipc	a0,0x2
    3a46:	68650513          	addi	a0,a0,1670 # 60c8 <malloc+0x5e8>
    3a4a:	00002097          	auipc	ra,0x2
    3a4e:	cc0080e7          	jalr	-832(ra) # 570a <link>
    3a52:	10050b63          	beqz	a0,3b68 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3a56:	00002517          	auipc	a0,0x2
    3a5a:	47a50513          	addi	a0,a0,1146 # 5ed0 <malloc+0x3f0>
    3a5e:	00002097          	auipc	ra,0x2
    3a62:	c9c080e7          	jalr	-868(ra) # 56fa <unlink>
    3a66:	10051f63          	bnez	a0,3b84 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3a6a:	4589                	li	a1,2
    3a6c:	00003517          	auipc	a0,0x3
    3a70:	b6450513          	addi	a0,a0,-1180 # 65d0 <malloc+0xaf0>
    3a74:	00002097          	auipc	ra,0x2
    3a78:	c76080e7          	jalr	-906(ra) # 56ea <open>
  if(fd >= 0){
    3a7c:	12055263          	bgez	a0,3ba0 <dirfile+0x1fc>
  fd = open(".", 0);
    3a80:	4581                	li	a1,0
    3a82:	00003517          	auipc	a0,0x3
    3a86:	b4e50513          	addi	a0,a0,-1202 # 65d0 <malloc+0xaf0>
    3a8a:	00002097          	auipc	ra,0x2
    3a8e:	c60080e7          	jalr	-928(ra) # 56ea <open>
    3a92:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3a94:	4605                	li	a2,1
    3a96:	00002597          	auipc	a1,0x2
    3a9a:	50a58593          	addi	a1,a1,1290 # 5fa0 <malloc+0x4c0>
    3a9e:	00002097          	auipc	ra,0x2
    3aa2:	c2c080e7          	jalr	-980(ra) # 56ca <write>
    3aa6:	10a04b63          	bgtz	a0,3bbc <dirfile+0x218>
  close(fd);
    3aaa:	8526                	mv	a0,s1
    3aac:	00002097          	auipc	ra,0x2
    3ab0:	c26080e7          	jalr	-986(ra) # 56d2 <close>
}
    3ab4:	60e2                	ld	ra,24(sp)
    3ab6:	6442                	ld	s0,16(sp)
    3ab8:	64a2                	ld	s1,8(sp)
    3aba:	6902                	ld	s2,0(sp)
    3abc:	6105                	addi	sp,sp,32
    3abe:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3ac0:	85ca                	mv	a1,s2
    3ac2:	00004517          	auipc	a0,0x4
    3ac6:	d3650513          	addi	a0,a0,-714 # 77f8 <malloc+0x1d18>
    3aca:	00002097          	auipc	ra,0x2
    3ace:	f58080e7          	jalr	-168(ra) # 5a22 <printf>
    exit(1);
    3ad2:	4505                	li	a0,1
    3ad4:	00002097          	auipc	ra,0x2
    3ad8:	bd6080e7          	jalr	-1066(ra) # 56aa <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3adc:	85ca                	mv	a1,s2
    3ade:	00004517          	auipc	a0,0x4
    3ae2:	d3a50513          	addi	a0,a0,-710 # 7818 <malloc+0x1d38>
    3ae6:	00002097          	auipc	ra,0x2
    3aea:	f3c080e7          	jalr	-196(ra) # 5a22 <printf>
    exit(1);
    3aee:	4505                	li	a0,1
    3af0:	00002097          	auipc	ra,0x2
    3af4:	bba080e7          	jalr	-1094(ra) # 56aa <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3af8:	85ca                	mv	a1,s2
    3afa:	00004517          	auipc	a0,0x4
    3afe:	d4e50513          	addi	a0,a0,-690 # 7848 <malloc+0x1d68>
    3b02:	00002097          	auipc	ra,0x2
    3b06:	f20080e7          	jalr	-224(ra) # 5a22 <printf>
    exit(1);
    3b0a:	4505                	li	a0,1
    3b0c:	00002097          	auipc	ra,0x2
    3b10:	b9e080e7          	jalr	-1122(ra) # 56aa <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3b14:	85ca                	mv	a1,s2
    3b16:	00004517          	auipc	a0,0x4
    3b1a:	d3250513          	addi	a0,a0,-718 # 7848 <malloc+0x1d68>
    3b1e:	00002097          	auipc	ra,0x2
    3b22:	f04080e7          	jalr	-252(ra) # 5a22 <printf>
    exit(1);
    3b26:	4505                	li	a0,1
    3b28:	00002097          	auipc	ra,0x2
    3b2c:	b82080e7          	jalr	-1150(ra) # 56aa <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3b30:	85ca                	mv	a1,s2
    3b32:	00004517          	auipc	a0,0x4
    3b36:	d3e50513          	addi	a0,a0,-706 # 7870 <malloc+0x1d90>
    3b3a:	00002097          	auipc	ra,0x2
    3b3e:	ee8080e7          	jalr	-280(ra) # 5a22 <printf>
    exit(1);
    3b42:	4505                	li	a0,1
    3b44:	00002097          	auipc	ra,0x2
    3b48:	b66080e7          	jalr	-1178(ra) # 56aa <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3b4c:	85ca                	mv	a1,s2
    3b4e:	00004517          	auipc	a0,0x4
    3b52:	d4a50513          	addi	a0,a0,-694 # 7898 <malloc+0x1db8>
    3b56:	00002097          	auipc	ra,0x2
    3b5a:	ecc080e7          	jalr	-308(ra) # 5a22 <printf>
    exit(1);
    3b5e:	4505                	li	a0,1
    3b60:	00002097          	auipc	ra,0x2
    3b64:	b4a080e7          	jalr	-1206(ra) # 56aa <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3b68:	85ca                	mv	a1,s2
    3b6a:	00004517          	auipc	a0,0x4
    3b6e:	d5650513          	addi	a0,a0,-682 # 78c0 <malloc+0x1de0>
    3b72:	00002097          	auipc	ra,0x2
    3b76:	eb0080e7          	jalr	-336(ra) # 5a22 <printf>
    exit(1);
    3b7a:	4505                	li	a0,1
    3b7c:	00002097          	auipc	ra,0x2
    3b80:	b2e080e7          	jalr	-1234(ra) # 56aa <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3b84:	85ca                	mv	a1,s2
    3b86:	00004517          	auipc	a0,0x4
    3b8a:	d6250513          	addi	a0,a0,-670 # 78e8 <malloc+0x1e08>
    3b8e:	00002097          	auipc	ra,0x2
    3b92:	e94080e7          	jalr	-364(ra) # 5a22 <printf>
    exit(1);
    3b96:	4505                	li	a0,1
    3b98:	00002097          	auipc	ra,0x2
    3b9c:	b12080e7          	jalr	-1262(ra) # 56aa <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3ba0:	85ca                	mv	a1,s2
    3ba2:	00004517          	auipc	a0,0x4
    3ba6:	d6650513          	addi	a0,a0,-666 # 7908 <malloc+0x1e28>
    3baa:	00002097          	auipc	ra,0x2
    3bae:	e78080e7          	jalr	-392(ra) # 5a22 <printf>
    exit(1);
    3bb2:	4505                	li	a0,1
    3bb4:	00002097          	auipc	ra,0x2
    3bb8:	af6080e7          	jalr	-1290(ra) # 56aa <exit>
    printf("%s: write . succeeded!\n", s);
    3bbc:	85ca                	mv	a1,s2
    3bbe:	00004517          	auipc	a0,0x4
    3bc2:	d7250513          	addi	a0,a0,-654 # 7930 <malloc+0x1e50>
    3bc6:	00002097          	auipc	ra,0x2
    3bca:	e5c080e7          	jalr	-420(ra) # 5a22 <printf>
    exit(1);
    3bce:	4505                	li	a0,1
    3bd0:	00002097          	auipc	ra,0x2
    3bd4:	ada080e7          	jalr	-1318(ra) # 56aa <exit>

0000000000003bd8 <iref>:
{
    3bd8:	7139                	addi	sp,sp,-64
    3bda:	fc06                	sd	ra,56(sp)
    3bdc:	f822                	sd	s0,48(sp)
    3bde:	f426                	sd	s1,40(sp)
    3be0:	f04a                	sd	s2,32(sp)
    3be2:	ec4e                	sd	s3,24(sp)
    3be4:	e852                	sd	s4,16(sp)
    3be6:	e456                	sd	s5,8(sp)
    3be8:	e05a                	sd	s6,0(sp)
    3bea:	0080                	addi	s0,sp,64
    3bec:	8b2a                	mv	s6,a0
    3bee:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3bf2:	00004a17          	auipc	s4,0x4
    3bf6:	d56a0a13          	addi	s4,s4,-682 # 7948 <malloc+0x1e68>
    mkdir("");
    3bfa:	00004497          	auipc	s1,0x4
    3bfe:	85e48493          	addi	s1,s1,-1954 # 7458 <malloc+0x1978>
    link("README.md", "");
    3c02:	00002a97          	auipc	s5,0x2
    3c06:	4c6a8a93          	addi	s5,s5,1222 # 60c8 <malloc+0x5e8>
    fd = open("xx", O_CREATE);
    3c0a:	00004997          	auipc	s3,0x4
    3c0e:	c3698993          	addi	s3,s3,-970 # 7840 <malloc+0x1d60>
    3c12:	a891                	j	3c66 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3c14:	85da                	mv	a1,s6
    3c16:	00004517          	auipc	a0,0x4
    3c1a:	d3a50513          	addi	a0,a0,-710 # 7950 <malloc+0x1e70>
    3c1e:	00002097          	auipc	ra,0x2
    3c22:	e04080e7          	jalr	-508(ra) # 5a22 <printf>
      exit(1);
    3c26:	4505                	li	a0,1
    3c28:	00002097          	auipc	ra,0x2
    3c2c:	a82080e7          	jalr	-1406(ra) # 56aa <exit>
      printf("%s: chdir irefd failed\n", s);
    3c30:	85da                	mv	a1,s6
    3c32:	00004517          	auipc	a0,0x4
    3c36:	d3650513          	addi	a0,a0,-714 # 7968 <malloc+0x1e88>
    3c3a:	00002097          	auipc	ra,0x2
    3c3e:	de8080e7          	jalr	-536(ra) # 5a22 <printf>
      exit(1);
    3c42:	4505                	li	a0,1
    3c44:	00002097          	auipc	ra,0x2
    3c48:	a66080e7          	jalr	-1434(ra) # 56aa <exit>
      close(fd);
    3c4c:	00002097          	auipc	ra,0x2
    3c50:	a86080e7          	jalr	-1402(ra) # 56d2 <close>
    3c54:	a889                	j	3ca6 <iref+0xce>
    unlink("xx");
    3c56:	854e                	mv	a0,s3
    3c58:	00002097          	auipc	ra,0x2
    3c5c:	aa2080e7          	jalr	-1374(ra) # 56fa <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3c60:	397d                	addiw	s2,s2,-1
    3c62:	06090063          	beqz	s2,3cc2 <iref+0xea>
    if(mkdir("irefd") != 0){
    3c66:	8552                	mv	a0,s4
    3c68:	00002097          	auipc	ra,0x2
    3c6c:	aaa080e7          	jalr	-1366(ra) # 5712 <mkdir>
    3c70:	f155                	bnez	a0,3c14 <iref+0x3c>
    if(chdir("irefd") != 0){
    3c72:	8552                	mv	a0,s4
    3c74:	00002097          	auipc	ra,0x2
    3c78:	aa6080e7          	jalr	-1370(ra) # 571a <chdir>
    3c7c:	f955                	bnez	a0,3c30 <iref+0x58>
    mkdir("");
    3c7e:	8526                	mv	a0,s1
    3c80:	00002097          	auipc	ra,0x2
    3c84:	a92080e7          	jalr	-1390(ra) # 5712 <mkdir>
    link("README.md", "");
    3c88:	85a6                	mv	a1,s1
    3c8a:	8556                	mv	a0,s5
    3c8c:	00002097          	auipc	ra,0x2
    3c90:	a7e080e7          	jalr	-1410(ra) # 570a <link>
    fd = open("", O_CREATE);
    3c94:	20000593          	li	a1,512
    3c98:	8526                	mv	a0,s1
    3c9a:	00002097          	auipc	ra,0x2
    3c9e:	a50080e7          	jalr	-1456(ra) # 56ea <open>
    if(fd >= 0)
    3ca2:	fa0555e3          	bgez	a0,3c4c <iref+0x74>
    fd = open("xx", O_CREATE);
    3ca6:	20000593          	li	a1,512
    3caa:	854e                	mv	a0,s3
    3cac:	00002097          	auipc	ra,0x2
    3cb0:	a3e080e7          	jalr	-1474(ra) # 56ea <open>
    if(fd >= 0)
    3cb4:	fa0541e3          	bltz	a0,3c56 <iref+0x7e>
      close(fd);
    3cb8:	00002097          	auipc	ra,0x2
    3cbc:	a1a080e7          	jalr	-1510(ra) # 56d2 <close>
    3cc0:	bf59                	j	3c56 <iref+0x7e>
    3cc2:	03300493          	li	s1,51
    chdir("..");
    3cc6:	00003997          	auipc	s3,0x3
    3cca:	4b298993          	addi	s3,s3,1202 # 7178 <malloc+0x1698>
    unlink("irefd");
    3cce:	00004917          	auipc	s2,0x4
    3cd2:	c7a90913          	addi	s2,s2,-902 # 7948 <malloc+0x1e68>
    chdir("..");
    3cd6:	854e                	mv	a0,s3
    3cd8:	00002097          	auipc	ra,0x2
    3cdc:	a42080e7          	jalr	-1470(ra) # 571a <chdir>
    unlink("irefd");
    3ce0:	854a                	mv	a0,s2
    3ce2:	00002097          	auipc	ra,0x2
    3ce6:	a18080e7          	jalr	-1512(ra) # 56fa <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3cea:	34fd                	addiw	s1,s1,-1
    3cec:	f4ed                	bnez	s1,3cd6 <iref+0xfe>
  chdir("/");
    3cee:	00003517          	auipc	a0,0x3
    3cf2:	43250513          	addi	a0,a0,1074 # 7120 <malloc+0x1640>
    3cf6:	00002097          	auipc	ra,0x2
    3cfa:	a24080e7          	jalr	-1500(ra) # 571a <chdir>
}
    3cfe:	70e2                	ld	ra,56(sp)
    3d00:	7442                	ld	s0,48(sp)
    3d02:	74a2                	ld	s1,40(sp)
    3d04:	7902                	ld	s2,32(sp)
    3d06:	69e2                	ld	s3,24(sp)
    3d08:	6a42                	ld	s4,16(sp)
    3d0a:	6aa2                	ld	s5,8(sp)
    3d0c:	6b02                	ld	s6,0(sp)
    3d0e:	6121                	addi	sp,sp,64
    3d10:	8082                	ret

0000000000003d12 <openiputtest>:
{
    3d12:	7179                	addi	sp,sp,-48
    3d14:	f406                	sd	ra,40(sp)
    3d16:	f022                	sd	s0,32(sp)
    3d18:	ec26                	sd	s1,24(sp)
    3d1a:	1800                	addi	s0,sp,48
    3d1c:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3d1e:	00004517          	auipc	a0,0x4
    3d22:	c6250513          	addi	a0,a0,-926 # 7980 <malloc+0x1ea0>
    3d26:	00002097          	auipc	ra,0x2
    3d2a:	9ec080e7          	jalr	-1556(ra) # 5712 <mkdir>
    3d2e:	04054263          	bltz	a0,3d72 <openiputtest+0x60>
  pid = fork();
    3d32:	00002097          	auipc	ra,0x2
    3d36:	970080e7          	jalr	-1680(ra) # 56a2 <fork>
  if(pid < 0){
    3d3a:	04054a63          	bltz	a0,3d8e <openiputtest+0x7c>
  if(pid == 0){
    3d3e:	e93d                	bnez	a0,3db4 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3d40:	4589                	li	a1,2
    3d42:	00004517          	auipc	a0,0x4
    3d46:	c3e50513          	addi	a0,a0,-962 # 7980 <malloc+0x1ea0>
    3d4a:	00002097          	auipc	ra,0x2
    3d4e:	9a0080e7          	jalr	-1632(ra) # 56ea <open>
    if(fd >= 0){
    3d52:	04054c63          	bltz	a0,3daa <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3d56:	85a6                	mv	a1,s1
    3d58:	00004517          	auipc	a0,0x4
    3d5c:	c4850513          	addi	a0,a0,-952 # 79a0 <malloc+0x1ec0>
    3d60:	00002097          	auipc	ra,0x2
    3d64:	cc2080e7          	jalr	-830(ra) # 5a22 <printf>
      exit(1);
    3d68:	4505                	li	a0,1
    3d6a:	00002097          	auipc	ra,0x2
    3d6e:	940080e7          	jalr	-1728(ra) # 56aa <exit>
    printf("%s: mkdir oidir failed\n", s);
    3d72:	85a6                	mv	a1,s1
    3d74:	00004517          	auipc	a0,0x4
    3d78:	c1450513          	addi	a0,a0,-1004 # 7988 <malloc+0x1ea8>
    3d7c:	00002097          	auipc	ra,0x2
    3d80:	ca6080e7          	jalr	-858(ra) # 5a22 <printf>
    exit(1);
    3d84:	4505                	li	a0,1
    3d86:	00002097          	auipc	ra,0x2
    3d8a:	924080e7          	jalr	-1756(ra) # 56aa <exit>
    printf("%s: fork failed\n", s);
    3d8e:	85a6                	mv	a1,s1
    3d90:	00003517          	auipc	a0,0x3
    3d94:	9e050513          	addi	a0,a0,-1568 # 6770 <malloc+0xc90>
    3d98:	00002097          	auipc	ra,0x2
    3d9c:	c8a080e7          	jalr	-886(ra) # 5a22 <printf>
    exit(1);
    3da0:	4505                	li	a0,1
    3da2:	00002097          	auipc	ra,0x2
    3da6:	908080e7          	jalr	-1784(ra) # 56aa <exit>
    exit(0);
    3daa:	4501                	li	a0,0
    3dac:	00002097          	auipc	ra,0x2
    3db0:	8fe080e7          	jalr	-1794(ra) # 56aa <exit>
  sleep(1);
    3db4:	4505                	li	a0,1
    3db6:	00002097          	auipc	ra,0x2
    3dba:	984080e7          	jalr	-1660(ra) # 573a <sleep>
  if(unlink("oidir") != 0){
    3dbe:	00004517          	auipc	a0,0x4
    3dc2:	bc250513          	addi	a0,a0,-1086 # 7980 <malloc+0x1ea0>
    3dc6:	00002097          	auipc	ra,0x2
    3dca:	934080e7          	jalr	-1740(ra) # 56fa <unlink>
    3dce:	cd19                	beqz	a0,3dec <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3dd0:	85a6                	mv	a1,s1
    3dd2:	00003517          	auipc	a0,0x3
    3dd6:	b8e50513          	addi	a0,a0,-1138 # 6960 <malloc+0xe80>
    3dda:	00002097          	auipc	ra,0x2
    3dde:	c48080e7          	jalr	-952(ra) # 5a22 <printf>
    exit(1);
    3de2:	4505                	li	a0,1
    3de4:	00002097          	auipc	ra,0x2
    3de8:	8c6080e7          	jalr	-1850(ra) # 56aa <exit>
  wait(&xstatus);
    3dec:	fdc40513          	addi	a0,s0,-36
    3df0:	00002097          	auipc	ra,0x2
    3df4:	8c2080e7          	jalr	-1854(ra) # 56b2 <wait>
  exit(xstatus);
    3df8:	fdc42503          	lw	a0,-36(s0)
    3dfc:	00002097          	auipc	ra,0x2
    3e00:	8ae080e7          	jalr	-1874(ra) # 56aa <exit>

0000000000003e04 <forkforkfork>:
{
    3e04:	1101                	addi	sp,sp,-32
    3e06:	ec06                	sd	ra,24(sp)
    3e08:	e822                	sd	s0,16(sp)
    3e0a:	e426                	sd	s1,8(sp)
    3e0c:	1000                	addi	s0,sp,32
    3e0e:	84aa                	mv	s1,a0
  unlink("stopforking");
    3e10:	00004517          	auipc	a0,0x4
    3e14:	bb850513          	addi	a0,a0,-1096 # 79c8 <malloc+0x1ee8>
    3e18:	00002097          	auipc	ra,0x2
    3e1c:	8e2080e7          	jalr	-1822(ra) # 56fa <unlink>
  int pid = fork();
    3e20:	00002097          	auipc	ra,0x2
    3e24:	882080e7          	jalr	-1918(ra) # 56a2 <fork>
  if(pid < 0){
    3e28:	04054563          	bltz	a0,3e72 <forkforkfork+0x6e>
  if(pid == 0){
    3e2c:	c12d                	beqz	a0,3e8e <forkforkfork+0x8a>
  sleep(20); // two seconds
    3e2e:	4551                	li	a0,20
    3e30:	00002097          	auipc	ra,0x2
    3e34:	90a080e7          	jalr	-1782(ra) # 573a <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3e38:	20200593          	li	a1,514
    3e3c:	00004517          	auipc	a0,0x4
    3e40:	b8c50513          	addi	a0,a0,-1140 # 79c8 <malloc+0x1ee8>
    3e44:	00002097          	auipc	ra,0x2
    3e48:	8a6080e7          	jalr	-1882(ra) # 56ea <open>
    3e4c:	00002097          	auipc	ra,0x2
    3e50:	886080e7          	jalr	-1914(ra) # 56d2 <close>
  wait(0);
    3e54:	4501                	li	a0,0
    3e56:	00002097          	auipc	ra,0x2
    3e5a:	85c080e7          	jalr	-1956(ra) # 56b2 <wait>
  sleep(10); // one second
    3e5e:	4529                	li	a0,10
    3e60:	00002097          	auipc	ra,0x2
    3e64:	8da080e7          	jalr	-1830(ra) # 573a <sleep>
}
    3e68:	60e2                	ld	ra,24(sp)
    3e6a:	6442                	ld	s0,16(sp)
    3e6c:	64a2                	ld	s1,8(sp)
    3e6e:	6105                	addi	sp,sp,32
    3e70:	8082                	ret
    printf("%s: fork failed", s);
    3e72:	85a6                	mv	a1,s1
    3e74:	00003517          	auipc	a0,0x3
    3e78:	abc50513          	addi	a0,a0,-1348 # 6930 <malloc+0xe50>
    3e7c:	00002097          	auipc	ra,0x2
    3e80:	ba6080e7          	jalr	-1114(ra) # 5a22 <printf>
    exit(1);
    3e84:	4505                	li	a0,1
    3e86:	00002097          	auipc	ra,0x2
    3e8a:	824080e7          	jalr	-2012(ra) # 56aa <exit>
      int fd = open("stopforking", 0);
    3e8e:	00004497          	auipc	s1,0x4
    3e92:	b3a48493          	addi	s1,s1,-1222 # 79c8 <malloc+0x1ee8>
    3e96:	4581                	li	a1,0
    3e98:	8526                	mv	a0,s1
    3e9a:	00002097          	auipc	ra,0x2
    3e9e:	850080e7          	jalr	-1968(ra) # 56ea <open>
      if(fd >= 0){
    3ea2:	02055463          	bgez	a0,3eca <forkforkfork+0xc6>
      if(fork() < 0){
    3ea6:	00001097          	auipc	ra,0x1
    3eaa:	7fc080e7          	jalr	2044(ra) # 56a2 <fork>
    3eae:	fe0554e3          	bgez	a0,3e96 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    3eb2:	20200593          	li	a1,514
    3eb6:	8526                	mv	a0,s1
    3eb8:	00002097          	auipc	ra,0x2
    3ebc:	832080e7          	jalr	-1998(ra) # 56ea <open>
    3ec0:	00002097          	auipc	ra,0x2
    3ec4:	812080e7          	jalr	-2030(ra) # 56d2 <close>
    3ec8:	b7f9                	j	3e96 <forkforkfork+0x92>
        exit(0);
    3eca:	4501                	li	a0,0
    3ecc:	00001097          	auipc	ra,0x1
    3ed0:	7de080e7          	jalr	2014(ra) # 56aa <exit>

0000000000003ed4 <killstatus>:
{
    3ed4:	7139                	addi	sp,sp,-64
    3ed6:	fc06                	sd	ra,56(sp)
    3ed8:	f822                	sd	s0,48(sp)
    3eda:	f426                	sd	s1,40(sp)
    3edc:	f04a                	sd	s2,32(sp)
    3ede:	ec4e                	sd	s3,24(sp)
    3ee0:	e852                	sd	s4,16(sp)
    3ee2:	0080                	addi	s0,sp,64
    3ee4:	8a2a                	mv	s4,a0
    3ee6:	06400913          	li	s2,100
    if(xst != -1) {
    3eea:	59fd                	li	s3,-1
    int pid1 = fork();
    3eec:	00001097          	auipc	ra,0x1
    3ef0:	7b6080e7          	jalr	1974(ra) # 56a2 <fork>
    3ef4:	84aa                	mv	s1,a0
    if(pid1 < 0){
    3ef6:	02054f63          	bltz	a0,3f34 <killstatus+0x60>
    if(pid1 == 0){
    3efa:	c939                	beqz	a0,3f50 <killstatus+0x7c>
    sleep(1);
    3efc:	4505                	li	a0,1
    3efe:	00002097          	auipc	ra,0x2
    3f02:	83c080e7          	jalr	-1988(ra) # 573a <sleep>
    kill(pid1);
    3f06:	8526                	mv	a0,s1
    3f08:	00001097          	auipc	ra,0x1
    3f0c:	7d2080e7          	jalr	2002(ra) # 56da <kill>
    wait(&xst);
    3f10:	fcc40513          	addi	a0,s0,-52
    3f14:	00001097          	auipc	ra,0x1
    3f18:	79e080e7          	jalr	1950(ra) # 56b2 <wait>
    if(xst != -1) {
    3f1c:	fcc42783          	lw	a5,-52(s0)
    3f20:	03379d63          	bne	a5,s3,3f5a <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    3f24:	397d                	addiw	s2,s2,-1
    3f26:	fc0913e3          	bnez	s2,3eec <killstatus+0x18>
  exit(0);
    3f2a:	4501                	li	a0,0
    3f2c:	00001097          	auipc	ra,0x1
    3f30:	77e080e7          	jalr	1918(ra) # 56aa <exit>
      printf("%s: fork failed\n", s);
    3f34:	85d2                	mv	a1,s4
    3f36:	00003517          	auipc	a0,0x3
    3f3a:	83a50513          	addi	a0,a0,-1990 # 6770 <malloc+0xc90>
    3f3e:	00002097          	auipc	ra,0x2
    3f42:	ae4080e7          	jalr	-1308(ra) # 5a22 <printf>
      exit(1);
    3f46:	4505                	li	a0,1
    3f48:	00001097          	auipc	ra,0x1
    3f4c:	762080e7          	jalr	1890(ra) # 56aa <exit>
        getpid();
    3f50:	00001097          	auipc	ra,0x1
    3f54:	7da080e7          	jalr	2010(ra) # 572a <getpid>
      while(1) {
    3f58:	bfe5                	j	3f50 <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    3f5a:	85d2                	mv	a1,s4
    3f5c:	00004517          	auipc	a0,0x4
    3f60:	a7c50513          	addi	a0,a0,-1412 # 79d8 <malloc+0x1ef8>
    3f64:	00002097          	auipc	ra,0x2
    3f68:	abe080e7          	jalr	-1346(ra) # 5a22 <printf>
       exit(1);
    3f6c:	4505                	li	a0,1
    3f6e:	00001097          	auipc	ra,0x1
    3f72:	73c080e7          	jalr	1852(ra) # 56aa <exit>

0000000000003f76 <preempt>:
{
    3f76:	7139                	addi	sp,sp,-64
    3f78:	fc06                	sd	ra,56(sp)
    3f7a:	f822                	sd	s0,48(sp)
    3f7c:	f426                	sd	s1,40(sp)
    3f7e:	f04a                	sd	s2,32(sp)
    3f80:	ec4e                	sd	s3,24(sp)
    3f82:	e852                	sd	s4,16(sp)
    3f84:	0080                	addi	s0,sp,64
    3f86:	84aa                	mv	s1,a0
  pid1 = fork();
    3f88:	00001097          	auipc	ra,0x1
    3f8c:	71a080e7          	jalr	1818(ra) # 56a2 <fork>
  if(pid1 < 0) {
    3f90:	00054563          	bltz	a0,3f9a <preempt+0x24>
    3f94:	8a2a                	mv	s4,a0
  if(pid1 == 0)
    3f96:	e105                	bnez	a0,3fb6 <preempt+0x40>
    for(;;)
    3f98:	a001                	j	3f98 <preempt+0x22>
    printf("%s: fork failed", s);
    3f9a:	85a6                	mv	a1,s1
    3f9c:	00003517          	auipc	a0,0x3
    3fa0:	99450513          	addi	a0,a0,-1644 # 6930 <malloc+0xe50>
    3fa4:	00002097          	auipc	ra,0x2
    3fa8:	a7e080e7          	jalr	-1410(ra) # 5a22 <printf>
    exit(1);
    3fac:	4505                	li	a0,1
    3fae:	00001097          	auipc	ra,0x1
    3fb2:	6fc080e7          	jalr	1788(ra) # 56aa <exit>
  pid2 = fork();
    3fb6:	00001097          	auipc	ra,0x1
    3fba:	6ec080e7          	jalr	1772(ra) # 56a2 <fork>
    3fbe:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    3fc0:	00054463          	bltz	a0,3fc8 <preempt+0x52>
  if(pid2 == 0)
    3fc4:	e105                	bnez	a0,3fe4 <preempt+0x6e>
    for(;;)
    3fc6:	a001                	j	3fc6 <preempt+0x50>
    printf("%s: fork failed\n", s);
    3fc8:	85a6                	mv	a1,s1
    3fca:	00002517          	auipc	a0,0x2
    3fce:	7a650513          	addi	a0,a0,1958 # 6770 <malloc+0xc90>
    3fd2:	00002097          	auipc	ra,0x2
    3fd6:	a50080e7          	jalr	-1456(ra) # 5a22 <printf>
    exit(1);
    3fda:	4505                	li	a0,1
    3fdc:	00001097          	auipc	ra,0x1
    3fe0:	6ce080e7          	jalr	1742(ra) # 56aa <exit>
  pipe(pfds);
    3fe4:	fc840513          	addi	a0,s0,-56
    3fe8:	00001097          	auipc	ra,0x1
    3fec:	6d2080e7          	jalr	1746(ra) # 56ba <pipe>
  pid3 = fork();
    3ff0:	00001097          	auipc	ra,0x1
    3ff4:	6b2080e7          	jalr	1714(ra) # 56a2 <fork>
    3ff8:	892a                	mv	s2,a0
  if(pid3 < 0) {
    3ffa:	02054e63          	bltz	a0,4036 <preempt+0xc0>
  if(pid3 == 0){
    3ffe:	e525                	bnez	a0,4066 <preempt+0xf0>
    close(pfds[0]);
    4000:	fc842503          	lw	a0,-56(s0)
    4004:	00001097          	auipc	ra,0x1
    4008:	6ce080e7          	jalr	1742(ra) # 56d2 <close>
    if(write(pfds[1], "x", 1) != 1)
    400c:	4605                	li	a2,1
    400e:	00002597          	auipc	a1,0x2
    4012:	f9258593          	addi	a1,a1,-110 # 5fa0 <malloc+0x4c0>
    4016:	fcc42503          	lw	a0,-52(s0)
    401a:	00001097          	auipc	ra,0x1
    401e:	6b0080e7          	jalr	1712(ra) # 56ca <write>
    4022:	4785                	li	a5,1
    4024:	02f51763          	bne	a0,a5,4052 <preempt+0xdc>
    close(pfds[1]);
    4028:	fcc42503          	lw	a0,-52(s0)
    402c:	00001097          	auipc	ra,0x1
    4030:	6a6080e7          	jalr	1702(ra) # 56d2 <close>
    for(;;)
    4034:	a001                	j	4034 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    4036:	85a6                	mv	a1,s1
    4038:	00002517          	auipc	a0,0x2
    403c:	73850513          	addi	a0,a0,1848 # 6770 <malloc+0xc90>
    4040:	00002097          	auipc	ra,0x2
    4044:	9e2080e7          	jalr	-1566(ra) # 5a22 <printf>
     exit(1);
    4048:	4505                	li	a0,1
    404a:	00001097          	auipc	ra,0x1
    404e:	660080e7          	jalr	1632(ra) # 56aa <exit>
      printf("%s: preempt write error", s);
    4052:	85a6                	mv	a1,s1
    4054:	00004517          	auipc	a0,0x4
    4058:	9a450513          	addi	a0,a0,-1628 # 79f8 <malloc+0x1f18>
    405c:	00002097          	auipc	ra,0x2
    4060:	9c6080e7          	jalr	-1594(ra) # 5a22 <printf>
    4064:	b7d1                	j	4028 <preempt+0xb2>
  close(pfds[1]);
    4066:	fcc42503          	lw	a0,-52(s0)
    406a:	00001097          	auipc	ra,0x1
    406e:	668080e7          	jalr	1640(ra) # 56d2 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    4072:	660d                	lui	a2,0x3
    4074:	00008597          	auipc	a1,0x8
    4078:	b0c58593          	addi	a1,a1,-1268 # bb80 <buf>
    407c:	fc842503          	lw	a0,-56(s0)
    4080:	00001097          	auipc	ra,0x1
    4084:	642080e7          	jalr	1602(ra) # 56c2 <read>
    4088:	4785                	li	a5,1
    408a:	02f50363          	beq	a0,a5,40b0 <preempt+0x13a>
    printf("%s: preempt read error", s);
    408e:	85a6                	mv	a1,s1
    4090:	00004517          	auipc	a0,0x4
    4094:	98050513          	addi	a0,a0,-1664 # 7a10 <malloc+0x1f30>
    4098:	00002097          	auipc	ra,0x2
    409c:	98a080e7          	jalr	-1654(ra) # 5a22 <printf>
}
    40a0:	70e2                	ld	ra,56(sp)
    40a2:	7442                	ld	s0,48(sp)
    40a4:	74a2                	ld	s1,40(sp)
    40a6:	7902                	ld	s2,32(sp)
    40a8:	69e2                	ld	s3,24(sp)
    40aa:	6a42                	ld	s4,16(sp)
    40ac:	6121                	addi	sp,sp,64
    40ae:	8082                	ret
  close(pfds[0]);
    40b0:	fc842503          	lw	a0,-56(s0)
    40b4:	00001097          	auipc	ra,0x1
    40b8:	61e080e7          	jalr	1566(ra) # 56d2 <close>
  printf("kill... ");
    40bc:	00004517          	auipc	a0,0x4
    40c0:	96c50513          	addi	a0,a0,-1684 # 7a28 <malloc+0x1f48>
    40c4:	00002097          	auipc	ra,0x2
    40c8:	95e080e7          	jalr	-1698(ra) # 5a22 <printf>
  kill(pid1);
    40cc:	8552                	mv	a0,s4
    40ce:	00001097          	auipc	ra,0x1
    40d2:	60c080e7          	jalr	1548(ra) # 56da <kill>
  kill(pid2);
    40d6:	854e                	mv	a0,s3
    40d8:	00001097          	auipc	ra,0x1
    40dc:	602080e7          	jalr	1538(ra) # 56da <kill>
  kill(pid3);
    40e0:	854a                	mv	a0,s2
    40e2:	00001097          	auipc	ra,0x1
    40e6:	5f8080e7          	jalr	1528(ra) # 56da <kill>
  printf("wait... ");
    40ea:	00004517          	auipc	a0,0x4
    40ee:	94e50513          	addi	a0,a0,-1714 # 7a38 <malloc+0x1f58>
    40f2:	00002097          	auipc	ra,0x2
    40f6:	930080e7          	jalr	-1744(ra) # 5a22 <printf>
  wait(0);
    40fa:	4501                	li	a0,0
    40fc:	00001097          	auipc	ra,0x1
    4100:	5b6080e7          	jalr	1462(ra) # 56b2 <wait>
  wait(0);
    4104:	4501                	li	a0,0
    4106:	00001097          	auipc	ra,0x1
    410a:	5ac080e7          	jalr	1452(ra) # 56b2 <wait>
  wait(0);
    410e:	4501                	li	a0,0
    4110:	00001097          	auipc	ra,0x1
    4114:	5a2080e7          	jalr	1442(ra) # 56b2 <wait>
    4118:	b761                	j	40a0 <preempt+0x12a>

000000000000411a <reparent>:
{
    411a:	7179                	addi	sp,sp,-48
    411c:	f406                	sd	ra,40(sp)
    411e:	f022                	sd	s0,32(sp)
    4120:	ec26                	sd	s1,24(sp)
    4122:	e84a                	sd	s2,16(sp)
    4124:	e44e                	sd	s3,8(sp)
    4126:	e052                	sd	s4,0(sp)
    4128:	1800                	addi	s0,sp,48
    412a:	89aa                	mv	s3,a0
  int master_pid = getpid();
    412c:	00001097          	auipc	ra,0x1
    4130:	5fe080e7          	jalr	1534(ra) # 572a <getpid>
    4134:	8a2a                	mv	s4,a0
    4136:	0c800913          	li	s2,200
    int pid = fork();
    413a:	00001097          	auipc	ra,0x1
    413e:	568080e7          	jalr	1384(ra) # 56a2 <fork>
    4142:	84aa                	mv	s1,a0
    if(pid < 0){
    4144:	02054263          	bltz	a0,4168 <reparent+0x4e>
    if(pid){
    4148:	cd21                	beqz	a0,41a0 <reparent+0x86>
      if(wait(0) != pid){
    414a:	4501                	li	a0,0
    414c:	00001097          	auipc	ra,0x1
    4150:	566080e7          	jalr	1382(ra) # 56b2 <wait>
    4154:	02951863          	bne	a0,s1,4184 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    4158:	397d                	addiw	s2,s2,-1
    415a:	fe0910e3          	bnez	s2,413a <reparent+0x20>
  exit(0);
    415e:	4501                	li	a0,0
    4160:	00001097          	auipc	ra,0x1
    4164:	54a080e7          	jalr	1354(ra) # 56aa <exit>
      printf("%s: fork failed\n", s);
    4168:	85ce                	mv	a1,s3
    416a:	00002517          	auipc	a0,0x2
    416e:	60650513          	addi	a0,a0,1542 # 6770 <malloc+0xc90>
    4172:	00002097          	auipc	ra,0x2
    4176:	8b0080e7          	jalr	-1872(ra) # 5a22 <printf>
      exit(1);
    417a:	4505                	li	a0,1
    417c:	00001097          	auipc	ra,0x1
    4180:	52e080e7          	jalr	1326(ra) # 56aa <exit>
        printf("%s: wait wrong pid\n", s);
    4184:	85ce                	mv	a1,s3
    4186:	00002517          	auipc	a0,0x2
    418a:	77250513          	addi	a0,a0,1906 # 68f8 <malloc+0xe18>
    418e:	00002097          	auipc	ra,0x2
    4192:	894080e7          	jalr	-1900(ra) # 5a22 <printf>
        exit(1);
    4196:	4505                	li	a0,1
    4198:	00001097          	auipc	ra,0x1
    419c:	512080e7          	jalr	1298(ra) # 56aa <exit>
      int pid2 = fork();
    41a0:	00001097          	auipc	ra,0x1
    41a4:	502080e7          	jalr	1282(ra) # 56a2 <fork>
      if(pid2 < 0){
    41a8:	00054763          	bltz	a0,41b6 <reparent+0x9c>
      exit(0);
    41ac:	4501                	li	a0,0
    41ae:	00001097          	auipc	ra,0x1
    41b2:	4fc080e7          	jalr	1276(ra) # 56aa <exit>
        kill(master_pid);
    41b6:	8552                	mv	a0,s4
    41b8:	00001097          	auipc	ra,0x1
    41bc:	522080e7          	jalr	1314(ra) # 56da <kill>
        exit(1);
    41c0:	4505                	li	a0,1
    41c2:	00001097          	auipc	ra,0x1
    41c6:	4e8080e7          	jalr	1256(ra) # 56aa <exit>

00000000000041ca <sbrkfail>:
{
    41ca:	7119                	addi	sp,sp,-128
    41cc:	fc86                	sd	ra,120(sp)
    41ce:	f8a2                	sd	s0,112(sp)
    41d0:	f4a6                	sd	s1,104(sp)
    41d2:	f0ca                	sd	s2,96(sp)
    41d4:	ecce                	sd	s3,88(sp)
    41d6:	e8d2                	sd	s4,80(sp)
    41d8:	e4d6                	sd	s5,72(sp)
    41da:	0100                	addi	s0,sp,128
    41dc:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    41de:	fb040513          	addi	a0,s0,-80
    41e2:	00001097          	auipc	ra,0x1
    41e6:	4d8080e7          	jalr	1240(ra) # 56ba <pipe>
    41ea:	e901                	bnez	a0,41fa <sbrkfail+0x30>
    41ec:	f8040493          	addi	s1,s0,-128
    41f0:	fa840a13          	addi	s4,s0,-88
    41f4:	89a6                	mv	s3,s1
    if(pids[i] != -1)
    41f6:	5afd                	li	s5,-1
    41f8:	a08d                	j	425a <sbrkfail+0x90>
    printf("%s: pipe() failed\n", s);
    41fa:	85ca                	mv	a1,s2
    41fc:	00002517          	auipc	a0,0x2
    4200:	67c50513          	addi	a0,a0,1660 # 6878 <malloc+0xd98>
    4204:	00002097          	auipc	ra,0x2
    4208:	81e080e7          	jalr	-2018(ra) # 5a22 <printf>
    exit(1);
    420c:	4505                	li	a0,1
    420e:	00001097          	auipc	ra,0x1
    4212:	49c080e7          	jalr	1180(ra) # 56aa <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4216:	4501                	li	a0,0
    4218:	00001097          	auipc	ra,0x1
    421c:	51a080e7          	jalr	1306(ra) # 5732 <sbrk>
    4220:	064007b7          	lui	a5,0x6400
    4224:	40a7853b          	subw	a0,a5,a0
    4228:	00001097          	auipc	ra,0x1
    422c:	50a080e7          	jalr	1290(ra) # 5732 <sbrk>
      write(fds[1], "x", 1);
    4230:	4605                	li	a2,1
    4232:	00002597          	auipc	a1,0x2
    4236:	d6e58593          	addi	a1,a1,-658 # 5fa0 <malloc+0x4c0>
    423a:	fb442503          	lw	a0,-76(s0)
    423e:	00001097          	auipc	ra,0x1
    4242:	48c080e7          	jalr	1164(ra) # 56ca <write>
      for(;;) sleep(1000);
    4246:	3e800513          	li	a0,1000
    424a:	00001097          	auipc	ra,0x1
    424e:	4f0080e7          	jalr	1264(ra) # 573a <sleep>
    4252:	bfd5                	j	4246 <sbrkfail+0x7c>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4254:	0991                	addi	s3,s3,4
    4256:	03498563          	beq	s3,s4,4280 <sbrkfail+0xb6>
    if((pids[i] = fork()) == 0){
    425a:	00001097          	auipc	ra,0x1
    425e:	448080e7          	jalr	1096(ra) # 56a2 <fork>
    4262:	00a9a023          	sw	a0,0(s3)
    4266:	d945                	beqz	a0,4216 <sbrkfail+0x4c>
    if(pids[i] != -1)
    4268:	ff5506e3          	beq	a0,s5,4254 <sbrkfail+0x8a>
      read(fds[0], &scratch, 1);
    426c:	4605                	li	a2,1
    426e:	faf40593          	addi	a1,s0,-81
    4272:	fb042503          	lw	a0,-80(s0)
    4276:	00001097          	auipc	ra,0x1
    427a:	44c080e7          	jalr	1100(ra) # 56c2 <read>
    427e:	bfd9                	j	4254 <sbrkfail+0x8a>
  c = sbrk(PGSIZE);
    4280:	6505                	lui	a0,0x1
    4282:	00001097          	auipc	ra,0x1
    4286:	4b0080e7          	jalr	1200(ra) # 5732 <sbrk>
    428a:	89aa                	mv	s3,a0
    if(pids[i] == -1)
    428c:	5afd                	li	s5,-1
    428e:	a021                	j	4296 <sbrkfail+0xcc>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4290:	0491                	addi	s1,s1,4
    4292:	01448f63          	beq	s1,s4,42b0 <sbrkfail+0xe6>
    if(pids[i] == -1)
    4296:	4088                	lw	a0,0(s1)
    4298:	ff550ce3          	beq	a0,s5,4290 <sbrkfail+0xc6>
    kill(pids[i]);
    429c:	00001097          	auipc	ra,0x1
    42a0:	43e080e7          	jalr	1086(ra) # 56da <kill>
    wait(0);
    42a4:	4501                	li	a0,0
    42a6:	00001097          	auipc	ra,0x1
    42aa:	40c080e7          	jalr	1036(ra) # 56b2 <wait>
    42ae:	b7cd                	j	4290 <sbrkfail+0xc6>
  if(c == (char*)0xffffffffffffffffL){
    42b0:	57fd                	li	a5,-1
    42b2:	04f98163          	beq	s3,a5,42f4 <sbrkfail+0x12a>
  pid = fork();
    42b6:	00001097          	auipc	ra,0x1
    42ba:	3ec080e7          	jalr	1004(ra) # 56a2 <fork>
    42be:	84aa                	mv	s1,a0
  if(pid < 0){
    42c0:	04054863          	bltz	a0,4310 <sbrkfail+0x146>
  if(pid == 0){
    42c4:	c525                	beqz	a0,432c <sbrkfail+0x162>
  wait(&xstatus);
    42c6:	fbc40513          	addi	a0,s0,-68
    42ca:	00001097          	auipc	ra,0x1
    42ce:	3e8080e7          	jalr	1000(ra) # 56b2 <wait>
  if(xstatus != -1 && xstatus != 2)
    42d2:	fbc42783          	lw	a5,-68(s0)
    42d6:	577d                	li	a4,-1
    42d8:	00e78563          	beq	a5,a4,42e2 <sbrkfail+0x118>
    42dc:	4709                	li	a4,2
    42de:	08e79d63          	bne	a5,a4,4378 <sbrkfail+0x1ae>
}
    42e2:	70e6                	ld	ra,120(sp)
    42e4:	7446                	ld	s0,112(sp)
    42e6:	74a6                	ld	s1,104(sp)
    42e8:	7906                	ld	s2,96(sp)
    42ea:	69e6                	ld	s3,88(sp)
    42ec:	6a46                	ld	s4,80(sp)
    42ee:	6aa6                	ld	s5,72(sp)
    42f0:	6109                	addi	sp,sp,128
    42f2:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    42f4:	85ca                	mv	a1,s2
    42f6:	00003517          	auipc	a0,0x3
    42fa:	75250513          	addi	a0,a0,1874 # 7a48 <malloc+0x1f68>
    42fe:	00001097          	auipc	ra,0x1
    4302:	724080e7          	jalr	1828(ra) # 5a22 <printf>
    exit(1);
    4306:	4505                	li	a0,1
    4308:	00001097          	auipc	ra,0x1
    430c:	3a2080e7          	jalr	930(ra) # 56aa <exit>
    printf("%s: fork failed\n", s);
    4310:	85ca                	mv	a1,s2
    4312:	00002517          	auipc	a0,0x2
    4316:	45e50513          	addi	a0,a0,1118 # 6770 <malloc+0xc90>
    431a:	00001097          	auipc	ra,0x1
    431e:	708080e7          	jalr	1800(ra) # 5a22 <printf>
    exit(1);
    4322:	4505                	li	a0,1
    4324:	00001097          	auipc	ra,0x1
    4328:	386080e7          	jalr	902(ra) # 56aa <exit>
    a = sbrk(0);
    432c:	4501                	li	a0,0
    432e:	00001097          	auipc	ra,0x1
    4332:	404080e7          	jalr	1028(ra) # 5732 <sbrk>
    4336:	89aa                	mv	s3,a0
    sbrk(10*BIG);
    4338:	3e800537          	lui	a0,0x3e800
    433c:	00001097          	auipc	ra,0x1
    4340:	3f6080e7          	jalr	1014(ra) # 5732 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4344:	874e                	mv	a4,s3
    4346:	3e8007b7          	lui	a5,0x3e800
    434a:	97ce                	add	a5,a5,s3
    434c:	6685                	lui	a3,0x1
      n += *(a+i);
    434e:	00074603          	lbu	a2,0(a4)
    4352:	9cb1                	addw	s1,s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4354:	9736                	add	a4,a4,a3
    4356:	fef71ce3          	bne	a4,a5,434e <sbrkfail+0x184>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    435a:	8626                	mv	a2,s1
    435c:	85ca                	mv	a1,s2
    435e:	00003517          	auipc	a0,0x3
    4362:	70a50513          	addi	a0,a0,1802 # 7a68 <malloc+0x1f88>
    4366:	00001097          	auipc	ra,0x1
    436a:	6bc080e7          	jalr	1724(ra) # 5a22 <printf>
    exit(1);
    436e:	4505                	li	a0,1
    4370:	00001097          	auipc	ra,0x1
    4374:	33a080e7          	jalr	826(ra) # 56aa <exit>
    exit(1);
    4378:	4505                	li	a0,1
    437a:	00001097          	auipc	ra,0x1
    437e:	330080e7          	jalr	816(ra) # 56aa <exit>

0000000000004382 <mem>:
{
    4382:	7139                	addi	sp,sp,-64
    4384:	fc06                	sd	ra,56(sp)
    4386:	f822                	sd	s0,48(sp)
    4388:	f426                	sd	s1,40(sp)
    438a:	f04a                	sd	s2,32(sp)
    438c:	ec4e                	sd	s3,24(sp)
    438e:	0080                	addi	s0,sp,64
    4390:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    4392:	00001097          	auipc	ra,0x1
    4396:	310080e7          	jalr	784(ra) # 56a2 <fork>
    m1 = 0;
    439a:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    439c:	6909                	lui	s2,0x2
    439e:	71190913          	addi	s2,s2,1809 # 2711 <sbrkbasic+0x159>
  if((pid = fork()) == 0){
    43a2:	ed39                	bnez	a0,4400 <mem+0x7e>
    while((m2 = malloc(10001)) != 0){
    43a4:	854a                	mv	a0,s2
    43a6:	00001097          	auipc	ra,0x1
    43aa:	73a080e7          	jalr	1850(ra) # 5ae0 <malloc>
    43ae:	c501                	beqz	a0,43b6 <mem+0x34>
      *(char**)m2 = m1;
    43b0:	e104                	sd	s1,0(a0)
      m1 = m2;
    43b2:	84aa                	mv	s1,a0
    43b4:	bfc5                	j	43a4 <mem+0x22>
    while(m1){
    43b6:	c881                	beqz	s1,43c6 <mem+0x44>
      m2 = *(char**)m1;
    43b8:	8526                	mv	a0,s1
    43ba:	6084                	ld	s1,0(s1)
      free(m1);
    43bc:	00001097          	auipc	ra,0x1
    43c0:	69c080e7          	jalr	1692(ra) # 5a58 <free>
    while(m1){
    43c4:	f8f5                	bnez	s1,43b8 <mem+0x36>
    m1 = malloc(1024*20);
    43c6:	6515                	lui	a0,0x5
    43c8:	00001097          	auipc	ra,0x1
    43cc:	718080e7          	jalr	1816(ra) # 5ae0 <malloc>
    if(m1 == 0){
    43d0:	c911                	beqz	a0,43e4 <mem+0x62>
    free(m1);
    43d2:	00001097          	auipc	ra,0x1
    43d6:	686080e7          	jalr	1670(ra) # 5a58 <free>
    exit(0);
    43da:	4501                	li	a0,0
    43dc:	00001097          	auipc	ra,0x1
    43e0:	2ce080e7          	jalr	718(ra) # 56aa <exit>
      printf("couldn't allocate mem?!!\n", s);
    43e4:	85ce                	mv	a1,s3
    43e6:	00003517          	auipc	a0,0x3
    43ea:	6b250513          	addi	a0,a0,1714 # 7a98 <malloc+0x1fb8>
    43ee:	00001097          	auipc	ra,0x1
    43f2:	634080e7          	jalr	1588(ra) # 5a22 <printf>
      exit(1);
    43f6:	4505                	li	a0,1
    43f8:	00001097          	auipc	ra,0x1
    43fc:	2b2080e7          	jalr	690(ra) # 56aa <exit>
    wait(&xstatus);
    4400:	fcc40513          	addi	a0,s0,-52
    4404:	00001097          	auipc	ra,0x1
    4408:	2ae080e7          	jalr	686(ra) # 56b2 <wait>
    if(xstatus == -1){
    440c:	fcc42503          	lw	a0,-52(s0)
    4410:	57fd                	li	a5,-1
    4412:	00f50663          	beq	a0,a5,441e <mem+0x9c>
    exit(xstatus);
    4416:	00001097          	auipc	ra,0x1
    441a:	294080e7          	jalr	660(ra) # 56aa <exit>
      exit(0);
    441e:	4501                	li	a0,0
    4420:	00001097          	auipc	ra,0x1
    4424:	28a080e7          	jalr	650(ra) # 56aa <exit>

0000000000004428 <sharedfd>:
{
    4428:	7159                	addi	sp,sp,-112
    442a:	f486                	sd	ra,104(sp)
    442c:	f0a2                	sd	s0,96(sp)
    442e:	eca6                	sd	s1,88(sp)
    4430:	e8ca                	sd	s2,80(sp)
    4432:	e4ce                	sd	s3,72(sp)
    4434:	e0d2                	sd	s4,64(sp)
    4436:	fc56                	sd	s5,56(sp)
    4438:	f85a                	sd	s6,48(sp)
    443a:	f45e                	sd	s7,40(sp)
    443c:	1880                	addi	s0,sp,112
    443e:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4440:	00002517          	auipc	a0,0x2
    4444:	92050513          	addi	a0,a0,-1760 # 5d60 <malloc+0x280>
    4448:	00001097          	auipc	ra,0x1
    444c:	2b2080e7          	jalr	690(ra) # 56fa <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4450:	20200593          	li	a1,514
    4454:	00002517          	auipc	a0,0x2
    4458:	90c50513          	addi	a0,a0,-1780 # 5d60 <malloc+0x280>
    445c:	00001097          	auipc	ra,0x1
    4460:	28e080e7          	jalr	654(ra) # 56ea <open>
  if(fd < 0){
    4464:	04054a63          	bltz	a0,44b8 <sharedfd+0x90>
    4468:	892a                	mv	s2,a0
  pid = fork();
    446a:	00001097          	auipc	ra,0x1
    446e:	238080e7          	jalr	568(ra) # 56a2 <fork>
    4472:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4474:	06300593          	li	a1,99
    4478:	c119                	beqz	a0,447e <sharedfd+0x56>
    447a:	07000593          	li	a1,112
    447e:	4629                	li	a2,10
    4480:	fa040513          	addi	a0,s0,-96
    4484:	00001097          	auipc	ra,0x1
    4488:	022080e7          	jalr	34(ra) # 54a6 <memset>
    448c:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4490:	4629                	li	a2,10
    4492:	fa040593          	addi	a1,s0,-96
    4496:	854a                	mv	a0,s2
    4498:	00001097          	auipc	ra,0x1
    449c:	232080e7          	jalr	562(ra) # 56ca <write>
    44a0:	47a9                	li	a5,10
    44a2:	02f51963          	bne	a0,a5,44d4 <sharedfd+0xac>
  for(i = 0; i < N; i++){
    44a6:	34fd                	addiw	s1,s1,-1
    44a8:	f4e5                	bnez	s1,4490 <sharedfd+0x68>
  if(pid == 0) {
    44aa:	04099363          	bnez	s3,44f0 <sharedfd+0xc8>
    exit(0);
    44ae:	4501                	li	a0,0
    44b0:	00001097          	auipc	ra,0x1
    44b4:	1fa080e7          	jalr	506(ra) # 56aa <exit>
    printf("%s: cannot open sharedfd for writing", s);
    44b8:	85d2                	mv	a1,s4
    44ba:	00003517          	auipc	a0,0x3
    44be:	5fe50513          	addi	a0,a0,1534 # 7ab8 <malloc+0x1fd8>
    44c2:	00001097          	auipc	ra,0x1
    44c6:	560080e7          	jalr	1376(ra) # 5a22 <printf>
    exit(1);
    44ca:	4505                	li	a0,1
    44cc:	00001097          	auipc	ra,0x1
    44d0:	1de080e7          	jalr	478(ra) # 56aa <exit>
      printf("%s: write sharedfd failed\n", s);
    44d4:	85d2                	mv	a1,s4
    44d6:	00003517          	auipc	a0,0x3
    44da:	60a50513          	addi	a0,a0,1546 # 7ae0 <malloc+0x2000>
    44de:	00001097          	auipc	ra,0x1
    44e2:	544080e7          	jalr	1348(ra) # 5a22 <printf>
      exit(1);
    44e6:	4505                	li	a0,1
    44e8:	00001097          	auipc	ra,0x1
    44ec:	1c2080e7          	jalr	450(ra) # 56aa <exit>
    wait(&xstatus);
    44f0:	f9c40513          	addi	a0,s0,-100
    44f4:	00001097          	auipc	ra,0x1
    44f8:	1be080e7          	jalr	446(ra) # 56b2 <wait>
    if(xstatus != 0)
    44fc:	f9c42983          	lw	s3,-100(s0)
    4500:	00098763          	beqz	s3,450e <sharedfd+0xe6>
      exit(xstatus);
    4504:	854e                	mv	a0,s3
    4506:	00001097          	auipc	ra,0x1
    450a:	1a4080e7          	jalr	420(ra) # 56aa <exit>
  close(fd);
    450e:	854a                	mv	a0,s2
    4510:	00001097          	auipc	ra,0x1
    4514:	1c2080e7          	jalr	450(ra) # 56d2 <close>
  fd = open("sharedfd", 0);
    4518:	4581                	li	a1,0
    451a:	00002517          	auipc	a0,0x2
    451e:	84650513          	addi	a0,a0,-1978 # 5d60 <malloc+0x280>
    4522:	00001097          	auipc	ra,0x1
    4526:	1c8080e7          	jalr	456(ra) # 56ea <open>
    452a:	8baa                	mv	s7,a0
  nc = np = 0;
    452c:	8ace                	mv	s5,s3
  if(fd < 0){
    452e:	02054563          	bltz	a0,4558 <sharedfd+0x130>
    4532:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4536:	06300493          	li	s1,99
      if(buf[i] == 'p')
    453a:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    453e:	4629                	li	a2,10
    4540:	fa040593          	addi	a1,s0,-96
    4544:	855e                	mv	a0,s7
    4546:	00001097          	auipc	ra,0x1
    454a:	17c080e7          	jalr	380(ra) # 56c2 <read>
    454e:	02a05f63          	blez	a0,458c <sharedfd+0x164>
    4552:	fa040793          	addi	a5,s0,-96
    4556:	a01d                	j	457c <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4558:	85d2                	mv	a1,s4
    455a:	00003517          	auipc	a0,0x3
    455e:	5a650513          	addi	a0,a0,1446 # 7b00 <malloc+0x2020>
    4562:	00001097          	auipc	ra,0x1
    4566:	4c0080e7          	jalr	1216(ra) # 5a22 <printf>
    exit(1);
    456a:	4505                	li	a0,1
    456c:	00001097          	auipc	ra,0x1
    4570:	13e080e7          	jalr	318(ra) # 56aa <exit>
        nc++;
    4574:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4576:	0785                	addi	a5,a5,1
    4578:	fd2783e3          	beq	a5,s2,453e <sharedfd+0x116>
      if(buf[i] == 'c')
    457c:	0007c703          	lbu	a4,0(a5) # 3e800000 <__BSS_END__+0x3e7f1470>
    4580:	fe970ae3          	beq	a4,s1,4574 <sharedfd+0x14c>
      if(buf[i] == 'p')
    4584:	ff6719e3          	bne	a4,s6,4576 <sharedfd+0x14e>
        np++;
    4588:	2a85                	addiw	s5,s5,1
    458a:	b7f5                	j	4576 <sharedfd+0x14e>
  close(fd);
    458c:	855e                	mv	a0,s7
    458e:	00001097          	auipc	ra,0x1
    4592:	144080e7          	jalr	324(ra) # 56d2 <close>
  unlink("sharedfd");
    4596:	00001517          	auipc	a0,0x1
    459a:	7ca50513          	addi	a0,a0,1994 # 5d60 <malloc+0x280>
    459e:	00001097          	auipc	ra,0x1
    45a2:	15c080e7          	jalr	348(ra) # 56fa <unlink>
  if(nc == N*SZ && np == N*SZ){
    45a6:	6789                	lui	a5,0x2
    45a8:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x158>
    45ac:	00f99763          	bne	s3,a5,45ba <sharedfd+0x192>
    45b0:	6789                	lui	a5,0x2
    45b2:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x158>
    45b6:	02fa8063          	beq	s5,a5,45d6 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    45ba:	85d2                	mv	a1,s4
    45bc:	00003517          	auipc	a0,0x3
    45c0:	56c50513          	addi	a0,a0,1388 # 7b28 <malloc+0x2048>
    45c4:	00001097          	auipc	ra,0x1
    45c8:	45e080e7          	jalr	1118(ra) # 5a22 <printf>
    exit(1);
    45cc:	4505                	li	a0,1
    45ce:	00001097          	auipc	ra,0x1
    45d2:	0dc080e7          	jalr	220(ra) # 56aa <exit>
    exit(0);
    45d6:	4501                	li	a0,0
    45d8:	00001097          	auipc	ra,0x1
    45dc:	0d2080e7          	jalr	210(ra) # 56aa <exit>

00000000000045e0 <fourfiles>:
{
    45e0:	7171                	addi	sp,sp,-176
    45e2:	f506                	sd	ra,168(sp)
    45e4:	f122                	sd	s0,160(sp)
    45e6:	ed26                	sd	s1,152(sp)
    45e8:	e94a                	sd	s2,144(sp)
    45ea:	e54e                	sd	s3,136(sp)
    45ec:	e152                	sd	s4,128(sp)
    45ee:	fcd6                	sd	s5,120(sp)
    45f0:	f8da                	sd	s6,112(sp)
    45f2:	f4de                	sd	s7,104(sp)
    45f4:	f0e2                	sd	s8,96(sp)
    45f6:	ece6                	sd	s9,88(sp)
    45f8:	e8ea                	sd	s10,80(sp)
    45fa:	e4ee                	sd	s11,72(sp)
    45fc:	1900                	addi	s0,sp,176
    45fe:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4600:	00001797          	auipc	a5,0x1
    4604:	5c878793          	addi	a5,a5,1480 # 5bc8 <malloc+0xe8>
    4608:	f6f43823          	sd	a5,-144(s0)
    460c:	00001797          	auipc	a5,0x1
    4610:	5c478793          	addi	a5,a5,1476 # 5bd0 <malloc+0xf0>
    4614:	f6f43c23          	sd	a5,-136(s0)
    4618:	00001797          	auipc	a5,0x1
    461c:	5c078793          	addi	a5,a5,1472 # 5bd8 <malloc+0xf8>
    4620:	f8f43023          	sd	a5,-128(s0)
    4624:	00001797          	auipc	a5,0x1
    4628:	5bc78793          	addi	a5,a5,1468 # 5be0 <malloc+0x100>
    462c:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4630:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4634:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4636:	4481                	li	s1,0
    4638:	4a11                	li	s4,4
    fname = names[pi];
    463a:	00093983          	ld	s3,0(s2)
    unlink(fname);
    463e:	854e                	mv	a0,s3
    4640:	00001097          	auipc	ra,0x1
    4644:	0ba080e7          	jalr	186(ra) # 56fa <unlink>
    pid = fork();
    4648:	00001097          	auipc	ra,0x1
    464c:	05a080e7          	jalr	90(ra) # 56a2 <fork>
    if(pid < 0){
    4650:	04054563          	bltz	a0,469a <fourfiles+0xba>
    if(pid == 0){
    4654:	c12d                	beqz	a0,46b6 <fourfiles+0xd6>
  for(pi = 0; pi < NCHILD; pi++){
    4656:	2485                	addiw	s1,s1,1
    4658:	0921                	addi	s2,s2,8
    465a:	ff4490e3          	bne	s1,s4,463a <fourfiles+0x5a>
    465e:	4491                	li	s1,4
    wait(&xstatus);
    4660:	f6c40513          	addi	a0,s0,-148
    4664:	00001097          	auipc	ra,0x1
    4668:	04e080e7          	jalr	78(ra) # 56b2 <wait>
    if(xstatus != 0)
    466c:	f6c42503          	lw	a0,-148(s0)
    4670:	ed69                	bnez	a0,474a <fourfiles+0x16a>
  for(pi = 0; pi < NCHILD; pi++){
    4672:	34fd                	addiw	s1,s1,-1
    4674:	f4f5                	bnez	s1,4660 <fourfiles+0x80>
    4676:	03000b13          	li	s6,48
    total = 0;
    467a:	f4a43c23          	sd	a0,-168(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    467e:	00007a17          	auipc	s4,0x7
    4682:	502a0a13          	addi	s4,s4,1282 # bb80 <buf>
    4686:	00007a97          	auipc	s5,0x7
    468a:	4fba8a93          	addi	s5,s5,1275 # bb81 <buf+0x1>
    if(total != N*SZ){
    468e:	6d05                	lui	s10,0x1
    4690:	770d0d13          	addi	s10,s10,1904 # 1770 <pipe1+0x32>
  for(i = 0; i < NCHILD; i++){
    4694:	03400d93          	li	s11,52
    4698:	a23d                	j	47c6 <fourfiles+0x1e6>
      printf("fork failed\n", s);
    469a:	85e6                	mv	a1,s9
    469c:	00002517          	auipc	a0,0x2
    46a0:	4dc50513          	addi	a0,a0,1244 # 6b78 <malloc+0x1098>
    46a4:	00001097          	auipc	ra,0x1
    46a8:	37e080e7          	jalr	894(ra) # 5a22 <printf>
      exit(1);
    46ac:	4505                	li	a0,1
    46ae:	00001097          	auipc	ra,0x1
    46b2:	ffc080e7          	jalr	-4(ra) # 56aa <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    46b6:	20200593          	li	a1,514
    46ba:	854e                	mv	a0,s3
    46bc:	00001097          	auipc	ra,0x1
    46c0:	02e080e7          	jalr	46(ra) # 56ea <open>
    46c4:	892a                	mv	s2,a0
      if(fd < 0){
    46c6:	04054763          	bltz	a0,4714 <fourfiles+0x134>
      memset(buf, '0'+pi, SZ);
    46ca:	1f400613          	li	a2,500
    46ce:	0304859b          	addiw	a1,s1,48
    46d2:	00007517          	auipc	a0,0x7
    46d6:	4ae50513          	addi	a0,a0,1198 # bb80 <buf>
    46da:	00001097          	auipc	ra,0x1
    46de:	dcc080e7          	jalr	-564(ra) # 54a6 <memset>
    46e2:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    46e4:	00007997          	auipc	s3,0x7
    46e8:	49c98993          	addi	s3,s3,1180 # bb80 <buf>
    46ec:	1f400613          	li	a2,500
    46f0:	85ce                	mv	a1,s3
    46f2:	854a                	mv	a0,s2
    46f4:	00001097          	auipc	ra,0x1
    46f8:	fd6080e7          	jalr	-42(ra) # 56ca <write>
    46fc:	85aa                	mv	a1,a0
    46fe:	1f400793          	li	a5,500
    4702:	02f51763          	bne	a0,a5,4730 <fourfiles+0x150>
      for(i = 0; i < N; i++){
    4706:	34fd                	addiw	s1,s1,-1
    4708:	f0f5                	bnez	s1,46ec <fourfiles+0x10c>
      exit(0);
    470a:	4501                	li	a0,0
    470c:	00001097          	auipc	ra,0x1
    4710:	f9e080e7          	jalr	-98(ra) # 56aa <exit>
        printf("create failed\n", s);
    4714:	85e6                	mv	a1,s9
    4716:	00003517          	auipc	a0,0x3
    471a:	42a50513          	addi	a0,a0,1066 # 7b40 <malloc+0x2060>
    471e:	00001097          	auipc	ra,0x1
    4722:	304080e7          	jalr	772(ra) # 5a22 <printf>
        exit(1);
    4726:	4505                	li	a0,1
    4728:	00001097          	auipc	ra,0x1
    472c:	f82080e7          	jalr	-126(ra) # 56aa <exit>
          printf("write failed %d\n", n);
    4730:	00003517          	auipc	a0,0x3
    4734:	42050513          	addi	a0,a0,1056 # 7b50 <malloc+0x2070>
    4738:	00001097          	auipc	ra,0x1
    473c:	2ea080e7          	jalr	746(ra) # 5a22 <printf>
          exit(1);
    4740:	4505                	li	a0,1
    4742:	00001097          	auipc	ra,0x1
    4746:	f68080e7          	jalr	-152(ra) # 56aa <exit>
      exit(xstatus);
    474a:	00001097          	auipc	ra,0x1
    474e:	f60080e7          	jalr	-160(ra) # 56aa <exit>
          printf("wrong char\n", s);
    4752:	85e6                	mv	a1,s9
    4754:	00003517          	auipc	a0,0x3
    4758:	41450513          	addi	a0,a0,1044 # 7b68 <malloc+0x2088>
    475c:	00001097          	auipc	ra,0x1
    4760:	2c6080e7          	jalr	710(ra) # 5a22 <printf>
          exit(1);
    4764:	4505                	li	a0,1
    4766:	00001097          	auipc	ra,0x1
    476a:	f44080e7          	jalr	-188(ra) # 56aa <exit>
      total += n;
    476e:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4772:	660d                	lui	a2,0x3
    4774:	85d2                	mv	a1,s4
    4776:	854e                	mv	a0,s3
    4778:	00001097          	auipc	ra,0x1
    477c:	f4a080e7          	jalr	-182(ra) # 56c2 <read>
    4780:	02a05363          	blez	a0,47a6 <fourfiles+0x1c6>
    4784:	00007797          	auipc	a5,0x7
    4788:	3fc78793          	addi	a5,a5,1020 # bb80 <buf>
    478c:	fff5069b          	addiw	a3,a0,-1
    4790:	1682                	slli	a3,a3,0x20
    4792:	9281                	srli	a3,a3,0x20
    4794:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    4796:	0007c703          	lbu	a4,0(a5)
    479a:	fa971ce3          	bne	a4,s1,4752 <fourfiles+0x172>
      for(j = 0; j < n; j++){
    479e:	0785                	addi	a5,a5,1
    47a0:	fed79be3          	bne	a5,a3,4796 <fourfiles+0x1b6>
    47a4:	b7e9                	j	476e <fourfiles+0x18e>
    close(fd);
    47a6:	854e                	mv	a0,s3
    47a8:	00001097          	auipc	ra,0x1
    47ac:	f2a080e7          	jalr	-214(ra) # 56d2 <close>
    if(total != N*SZ){
    47b0:	03a91963          	bne	s2,s10,47e2 <fourfiles+0x202>
    unlink(fname);
    47b4:	8562                	mv	a0,s8
    47b6:	00001097          	auipc	ra,0x1
    47ba:	f44080e7          	jalr	-188(ra) # 56fa <unlink>
  for(i = 0; i < NCHILD; i++){
    47be:	0ba1                	addi	s7,s7,8
    47c0:	2b05                	addiw	s6,s6,1
    47c2:	03bb0e63          	beq	s6,s11,47fe <fourfiles+0x21e>
    fname = names[i];
    47c6:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    47ca:	4581                	li	a1,0
    47cc:	8562                	mv	a0,s8
    47ce:	00001097          	auipc	ra,0x1
    47d2:	f1c080e7          	jalr	-228(ra) # 56ea <open>
    47d6:	89aa                	mv	s3,a0
    total = 0;
    47d8:	f5843903          	ld	s2,-168(s0)
        if(buf[j] != '0'+i){
    47dc:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    47e0:	bf49                	j	4772 <fourfiles+0x192>
      printf("wrong length %d\n", total);
    47e2:	85ca                	mv	a1,s2
    47e4:	00003517          	auipc	a0,0x3
    47e8:	39450513          	addi	a0,a0,916 # 7b78 <malloc+0x2098>
    47ec:	00001097          	auipc	ra,0x1
    47f0:	236080e7          	jalr	566(ra) # 5a22 <printf>
      exit(1);
    47f4:	4505                	li	a0,1
    47f6:	00001097          	auipc	ra,0x1
    47fa:	eb4080e7          	jalr	-332(ra) # 56aa <exit>
}
    47fe:	70aa                	ld	ra,168(sp)
    4800:	740a                	ld	s0,160(sp)
    4802:	64ea                	ld	s1,152(sp)
    4804:	694a                	ld	s2,144(sp)
    4806:	69aa                	ld	s3,136(sp)
    4808:	6a0a                	ld	s4,128(sp)
    480a:	7ae6                	ld	s5,120(sp)
    480c:	7b46                	ld	s6,112(sp)
    480e:	7ba6                	ld	s7,104(sp)
    4810:	7c06                	ld	s8,96(sp)
    4812:	6ce6                	ld	s9,88(sp)
    4814:	6d46                	ld	s10,80(sp)
    4816:	6da6                	ld	s11,72(sp)
    4818:	614d                	addi	sp,sp,176
    481a:	8082                	ret

000000000000481c <concreate>:
{
    481c:	7135                	addi	sp,sp,-160
    481e:	ed06                	sd	ra,152(sp)
    4820:	e922                	sd	s0,144(sp)
    4822:	e526                	sd	s1,136(sp)
    4824:	e14a                	sd	s2,128(sp)
    4826:	fcce                	sd	s3,120(sp)
    4828:	f8d2                	sd	s4,112(sp)
    482a:	f4d6                	sd	s5,104(sp)
    482c:	f0da                	sd	s6,96(sp)
    482e:	ecde                	sd	s7,88(sp)
    4830:	1100                	addi	s0,sp,160
    4832:	89aa                	mv	s3,a0
  file[0] = 'C';
    4834:	04300793          	li	a5,67
    4838:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    483c:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4840:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4842:	4b0d                	li	s6,3
    4844:	4a85                	li	s5,1
      link("C0", file);
    4846:	00003b97          	auipc	s7,0x3
    484a:	34ab8b93          	addi	s7,s7,842 # 7b90 <malloc+0x20b0>
  for(i = 0; i < N; i++){
    484e:	02800a13          	li	s4,40
    4852:	acc1                	j	4b22 <concreate+0x306>
      link("C0", file);
    4854:	fa840593          	addi	a1,s0,-88
    4858:	855e                	mv	a0,s7
    485a:	00001097          	auipc	ra,0x1
    485e:	eb0080e7          	jalr	-336(ra) # 570a <link>
    if(pid == 0) {
    4862:	a45d                	j	4b08 <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    4864:	4795                	li	a5,5
    4866:	02f9693b          	remw	s2,s2,a5
    486a:	4785                	li	a5,1
    486c:	02f90b63          	beq	s2,a5,48a2 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4870:	20200593          	li	a1,514
    4874:	fa840513          	addi	a0,s0,-88
    4878:	00001097          	auipc	ra,0x1
    487c:	e72080e7          	jalr	-398(ra) # 56ea <open>
      if(fd < 0){
    4880:	26055b63          	bgez	a0,4af6 <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    4884:	fa840593          	addi	a1,s0,-88
    4888:	00003517          	auipc	a0,0x3
    488c:	31050513          	addi	a0,a0,784 # 7b98 <malloc+0x20b8>
    4890:	00001097          	auipc	ra,0x1
    4894:	192080e7          	jalr	402(ra) # 5a22 <printf>
        exit(1);
    4898:	4505                	li	a0,1
    489a:	00001097          	auipc	ra,0x1
    489e:	e10080e7          	jalr	-496(ra) # 56aa <exit>
      link("C0", file);
    48a2:	fa840593          	addi	a1,s0,-88
    48a6:	00003517          	auipc	a0,0x3
    48aa:	2ea50513          	addi	a0,a0,746 # 7b90 <malloc+0x20b0>
    48ae:	00001097          	auipc	ra,0x1
    48b2:	e5c080e7          	jalr	-420(ra) # 570a <link>
      exit(0);
    48b6:	4501                	li	a0,0
    48b8:	00001097          	auipc	ra,0x1
    48bc:	df2080e7          	jalr	-526(ra) # 56aa <exit>
        exit(1);
    48c0:	4505                	li	a0,1
    48c2:	00001097          	auipc	ra,0x1
    48c6:	de8080e7          	jalr	-536(ra) # 56aa <exit>
  memset(fa, 0, sizeof(fa));
    48ca:	02800613          	li	a2,40
    48ce:	4581                	li	a1,0
    48d0:	f8040513          	addi	a0,s0,-128
    48d4:	00001097          	auipc	ra,0x1
    48d8:	bd2080e7          	jalr	-1070(ra) # 54a6 <memset>
  fd = open(".", 0);
    48dc:	4581                	li	a1,0
    48de:	00002517          	auipc	a0,0x2
    48e2:	cf250513          	addi	a0,a0,-782 # 65d0 <malloc+0xaf0>
    48e6:	00001097          	auipc	ra,0x1
    48ea:	e04080e7          	jalr	-508(ra) # 56ea <open>
    48ee:	892a                	mv	s2,a0
  n = 0;
    48f0:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    48f2:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    48f6:	02700b13          	li	s6,39
      fa[i] = 1;
    48fa:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    48fc:	a03d                	j	492a <concreate+0x10e>
        printf("%s: concreate weird file %s\n", s, de.name);
    48fe:	f7240613          	addi	a2,s0,-142
    4902:	85ce                	mv	a1,s3
    4904:	00003517          	auipc	a0,0x3
    4908:	2b450513          	addi	a0,a0,692 # 7bb8 <malloc+0x20d8>
    490c:	00001097          	auipc	ra,0x1
    4910:	116080e7          	jalr	278(ra) # 5a22 <printf>
        exit(1);
    4914:	4505                	li	a0,1
    4916:	00001097          	auipc	ra,0x1
    491a:	d94080e7          	jalr	-620(ra) # 56aa <exit>
      fa[i] = 1;
    491e:	fb040793          	addi	a5,s0,-80
    4922:	973e                	add	a4,a4,a5
    4924:	fd770823          	sb	s7,-48(a4)
      n++;
    4928:	2a85                	addiw	s5,s5,1
  while(read(fd, &de, sizeof(de)) > 0){
    492a:	4641                	li	a2,16
    492c:	f7040593          	addi	a1,s0,-144
    4930:	854a                	mv	a0,s2
    4932:	00001097          	auipc	ra,0x1
    4936:	d90080e7          	jalr	-624(ra) # 56c2 <read>
    493a:	04a05a63          	blez	a0,498e <concreate+0x172>
    if(de.inum == 0)
    493e:	f7045783          	lhu	a5,-144(s0)
    4942:	d7e5                	beqz	a5,492a <concreate+0x10e>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4944:	f7244783          	lbu	a5,-142(s0)
    4948:	ff4791e3          	bne	a5,s4,492a <concreate+0x10e>
    494c:	f7444783          	lbu	a5,-140(s0)
    4950:	ffe9                	bnez	a5,492a <concreate+0x10e>
      i = de.name[1] - '0';
    4952:	f7344783          	lbu	a5,-141(s0)
    4956:	fd07879b          	addiw	a5,a5,-48
    495a:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    495e:	faeb60e3          	bltu	s6,a4,48fe <concreate+0xe2>
      if(fa[i]){
    4962:	fb040793          	addi	a5,s0,-80
    4966:	97ba                	add	a5,a5,a4
    4968:	fd07c783          	lbu	a5,-48(a5)
    496c:	dbcd                	beqz	a5,491e <concreate+0x102>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    496e:	f7240613          	addi	a2,s0,-142
    4972:	85ce                	mv	a1,s3
    4974:	00003517          	auipc	a0,0x3
    4978:	26450513          	addi	a0,a0,612 # 7bd8 <malloc+0x20f8>
    497c:	00001097          	auipc	ra,0x1
    4980:	0a6080e7          	jalr	166(ra) # 5a22 <printf>
        exit(1);
    4984:	4505                	li	a0,1
    4986:	00001097          	auipc	ra,0x1
    498a:	d24080e7          	jalr	-732(ra) # 56aa <exit>
  close(fd);
    498e:	854a                	mv	a0,s2
    4990:	00001097          	auipc	ra,0x1
    4994:	d42080e7          	jalr	-702(ra) # 56d2 <close>
  if(n != N){
    4998:	02800793          	li	a5,40
    499c:	00fa9763          	bne	s5,a5,49aa <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    49a0:	4a8d                	li	s5,3
    49a2:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    49a4:	02800a13          	li	s4,40
    49a8:	a8c9                	j	4a7a <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    49aa:	85ce                	mv	a1,s3
    49ac:	00003517          	auipc	a0,0x3
    49b0:	25450513          	addi	a0,a0,596 # 7c00 <malloc+0x2120>
    49b4:	00001097          	auipc	ra,0x1
    49b8:	06e080e7          	jalr	110(ra) # 5a22 <printf>
    exit(1);
    49bc:	4505                	li	a0,1
    49be:	00001097          	auipc	ra,0x1
    49c2:	cec080e7          	jalr	-788(ra) # 56aa <exit>
      printf("%s: fork failed\n", s);
    49c6:	85ce                	mv	a1,s3
    49c8:	00002517          	auipc	a0,0x2
    49cc:	da850513          	addi	a0,a0,-600 # 6770 <malloc+0xc90>
    49d0:	00001097          	auipc	ra,0x1
    49d4:	052080e7          	jalr	82(ra) # 5a22 <printf>
      exit(1);
    49d8:	4505                	li	a0,1
    49da:	00001097          	auipc	ra,0x1
    49de:	cd0080e7          	jalr	-816(ra) # 56aa <exit>
      close(open(file, 0));
    49e2:	4581                	li	a1,0
    49e4:	fa840513          	addi	a0,s0,-88
    49e8:	00001097          	auipc	ra,0x1
    49ec:	d02080e7          	jalr	-766(ra) # 56ea <open>
    49f0:	00001097          	auipc	ra,0x1
    49f4:	ce2080e7          	jalr	-798(ra) # 56d2 <close>
      close(open(file, 0));
    49f8:	4581                	li	a1,0
    49fa:	fa840513          	addi	a0,s0,-88
    49fe:	00001097          	auipc	ra,0x1
    4a02:	cec080e7          	jalr	-788(ra) # 56ea <open>
    4a06:	00001097          	auipc	ra,0x1
    4a0a:	ccc080e7          	jalr	-820(ra) # 56d2 <close>
      close(open(file, 0));
    4a0e:	4581                	li	a1,0
    4a10:	fa840513          	addi	a0,s0,-88
    4a14:	00001097          	auipc	ra,0x1
    4a18:	cd6080e7          	jalr	-810(ra) # 56ea <open>
    4a1c:	00001097          	auipc	ra,0x1
    4a20:	cb6080e7          	jalr	-842(ra) # 56d2 <close>
      close(open(file, 0));
    4a24:	4581                	li	a1,0
    4a26:	fa840513          	addi	a0,s0,-88
    4a2a:	00001097          	auipc	ra,0x1
    4a2e:	cc0080e7          	jalr	-832(ra) # 56ea <open>
    4a32:	00001097          	auipc	ra,0x1
    4a36:	ca0080e7          	jalr	-864(ra) # 56d2 <close>
      close(open(file, 0));
    4a3a:	4581                	li	a1,0
    4a3c:	fa840513          	addi	a0,s0,-88
    4a40:	00001097          	auipc	ra,0x1
    4a44:	caa080e7          	jalr	-854(ra) # 56ea <open>
    4a48:	00001097          	auipc	ra,0x1
    4a4c:	c8a080e7          	jalr	-886(ra) # 56d2 <close>
      close(open(file, 0));
    4a50:	4581                	li	a1,0
    4a52:	fa840513          	addi	a0,s0,-88
    4a56:	00001097          	auipc	ra,0x1
    4a5a:	c94080e7          	jalr	-876(ra) # 56ea <open>
    4a5e:	00001097          	auipc	ra,0x1
    4a62:	c74080e7          	jalr	-908(ra) # 56d2 <close>
    if(pid == 0)
    4a66:	08090363          	beqz	s2,4aec <concreate+0x2d0>
      wait(0);
    4a6a:	4501                	li	a0,0
    4a6c:	00001097          	auipc	ra,0x1
    4a70:	c46080e7          	jalr	-954(ra) # 56b2 <wait>
  for(i = 0; i < N; i++){
    4a74:	2485                	addiw	s1,s1,1
    4a76:	0f448563          	beq	s1,s4,4b60 <concreate+0x344>
    file[1] = '0' + i;
    4a7a:	0304879b          	addiw	a5,s1,48
    4a7e:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4a82:	00001097          	auipc	ra,0x1
    4a86:	c20080e7          	jalr	-992(ra) # 56a2 <fork>
    4a8a:	892a                	mv	s2,a0
    if(pid < 0){
    4a8c:	f2054de3          	bltz	a0,49c6 <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    4a90:	0354e73b          	remw	a4,s1,s5
    4a94:	00a767b3          	or	a5,a4,a0
    4a98:	2781                	sext.w	a5,a5
    4a9a:	d7a1                	beqz	a5,49e2 <concreate+0x1c6>
    4a9c:	01671363          	bne	a4,s6,4aa2 <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    4aa0:	f129                	bnez	a0,49e2 <concreate+0x1c6>
      unlink(file);
    4aa2:	fa840513          	addi	a0,s0,-88
    4aa6:	00001097          	auipc	ra,0x1
    4aaa:	c54080e7          	jalr	-940(ra) # 56fa <unlink>
      unlink(file);
    4aae:	fa840513          	addi	a0,s0,-88
    4ab2:	00001097          	auipc	ra,0x1
    4ab6:	c48080e7          	jalr	-952(ra) # 56fa <unlink>
      unlink(file);
    4aba:	fa840513          	addi	a0,s0,-88
    4abe:	00001097          	auipc	ra,0x1
    4ac2:	c3c080e7          	jalr	-964(ra) # 56fa <unlink>
      unlink(file);
    4ac6:	fa840513          	addi	a0,s0,-88
    4aca:	00001097          	auipc	ra,0x1
    4ace:	c30080e7          	jalr	-976(ra) # 56fa <unlink>
      unlink(file);
    4ad2:	fa840513          	addi	a0,s0,-88
    4ad6:	00001097          	auipc	ra,0x1
    4ada:	c24080e7          	jalr	-988(ra) # 56fa <unlink>
      unlink(file);
    4ade:	fa840513          	addi	a0,s0,-88
    4ae2:	00001097          	auipc	ra,0x1
    4ae6:	c18080e7          	jalr	-1000(ra) # 56fa <unlink>
    4aea:	bfb5                	j	4a66 <concreate+0x24a>
      exit(0);
    4aec:	4501                	li	a0,0
    4aee:	00001097          	auipc	ra,0x1
    4af2:	bbc080e7          	jalr	-1092(ra) # 56aa <exit>
      close(fd);
    4af6:	00001097          	auipc	ra,0x1
    4afa:	bdc080e7          	jalr	-1060(ra) # 56d2 <close>
    if(pid == 0) {
    4afe:	bb65                	j	48b6 <concreate+0x9a>
      close(fd);
    4b00:	00001097          	auipc	ra,0x1
    4b04:	bd2080e7          	jalr	-1070(ra) # 56d2 <close>
      wait(&xstatus);
    4b08:	f6c40513          	addi	a0,s0,-148
    4b0c:	00001097          	auipc	ra,0x1
    4b10:	ba6080e7          	jalr	-1114(ra) # 56b2 <wait>
      if(xstatus != 0)
    4b14:	f6c42483          	lw	s1,-148(s0)
    4b18:	da0494e3          	bnez	s1,48c0 <concreate+0xa4>
  for(i = 0; i < N; i++){
    4b1c:	2905                	addiw	s2,s2,1
    4b1e:	db4906e3          	beq	s2,s4,48ca <concreate+0xae>
    file[1] = '0' + i;
    4b22:	0309079b          	addiw	a5,s2,48
    4b26:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4b2a:	fa840513          	addi	a0,s0,-88
    4b2e:	00001097          	auipc	ra,0x1
    4b32:	bcc080e7          	jalr	-1076(ra) # 56fa <unlink>
    pid = fork();
    4b36:	00001097          	auipc	ra,0x1
    4b3a:	b6c080e7          	jalr	-1172(ra) # 56a2 <fork>
    if(pid && (i % 3) == 1){
    4b3e:	d20503e3          	beqz	a0,4864 <concreate+0x48>
    4b42:	036967bb          	remw	a5,s2,s6
    4b46:	d15787e3          	beq	a5,s5,4854 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4b4a:	20200593          	li	a1,514
    4b4e:	fa840513          	addi	a0,s0,-88
    4b52:	00001097          	auipc	ra,0x1
    4b56:	b98080e7          	jalr	-1128(ra) # 56ea <open>
      if(fd < 0){
    4b5a:	fa0553e3          	bgez	a0,4b00 <concreate+0x2e4>
    4b5e:	b31d                	j	4884 <concreate+0x68>
}
    4b60:	60ea                	ld	ra,152(sp)
    4b62:	644a                	ld	s0,144(sp)
    4b64:	64aa                	ld	s1,136(sp)
    4b66:	690a                	ld	s2,128(sp)
    4b68:	79e6                	ld	s3,120(sp)
    4b6a:	7a46                	ld	s4,112(sp)
    4b6c:	7aa6                	ld	s5,104(sp)
    4b6e:	7b06                	ld	s6,96(sp)
    4b70:	6be6                	ld	s7,88(sp)
    4b72:	610d                	addi	sp,sp,160
    4b74:	8082                	ret

0000000000004b76 <bigfile>:
{
    4b76:	7139                	addi	sp,sp,-64
    4b78:	fc06                	sd	ra,56(sp)
    4b7a:	f822                	sd	s0,48(sp)
    4b7c:	f426                	sd	s1,40(sp)
    4b7e:	f04a                	sd	s2,32(sp)
    4b80:	ec4e                	sd	s3,24(sp)
    4b82:	e852                	sd	s4,16(sp)
    4b84:	e456                	sd	s5,8(sp)
    4b86:	0080                	addi	s0,sp,64
    4b88:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4b8a:	00003517          	auipc	a0,0x3
    4b8e:	0ae50513          	addi	a0,a0,174 # 7c38 <malloc+0x2158>
    4b92:	00001097          	auipc	ra,0x1
    4b96:	b68080e7          	jalr	-1176(ra) # 56fa <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4b9a:	20200593          	li	a1,514
    4b9e:	00003517          	auipc	a0,0x3
    4ba2:	09a50513          	addi	a0,a0,154 # 7c38 <malloc+0x2158>
    4ba6:	00001097          	auipc	ra,0x1
    4baa:	b44080e7          	jalr	-1212(ra) # 56ea <open>
    4bae:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4bb0:	4481                	li	s1,0
    memset(buf, i, SZ);
    4bb2:	00007917          	auipc	s2,0x7
    4bb6:	fce90913          	addi	s2,s2,-50 # bb80 <buf>
  for(i = 0; i < N; i++){
    4bba:	4a51                	li	s4,20
  if(fd < 0){
    4bbc:	0a054063          	bltz	a0,4c5c <bigfile+0xe6>
    memset(buf, i, SZ);
    4bc0:	25800613          	li	a2,600
    4bc4:	85a6                	mv	a1,s1
    4bc6:	854a                	mv	a0,s2
    4bc8:	00001097          	auipc	ra,0x1
    4bcc:	8de080e7          	jalr	-1826(ra) # 54a6 <memset>
    if(write(fd, buf, SZ) != SZ){
    4bd0:	25800613          	li	a2,600
    4bd4:	85ca                	mv	a1,s2
    4bd6:	854e                	mv	a0,s3
    4bd8:	00001097          	auipc	ra,0x1
    4bdc:	af2080e7          	jalr	-1294(ra) # 56ca <write>
    4be0:	25800793          	li	a5,600
    4be4:	08f51a63          	bne	a0,a5,4c78 <bigfile+0x102>
  for(i = 0; i < N; i++){
    4be8:	2485                	addiw	s1,s1,1
    4bea:	fd449be3          	bne	s1,s4,4bc0 <bigfile+0x4a>
  close(fd);
    4bee:	854e                	mv	a0,s3
    4bf0:	00001097          	auipc	ra,0x1
    4bf4:	ae2080e7          	jalr	-1310(ra) # 56d2 <close>
  fd = open("bigfile.dat", 0);
    4bf8:	4581                	li	a1,0
    4bfa:	00003517          	auipc	a0,0x3
    4bfe:	03e50513          	addi	a0,a0,62 # 7c38 <malloc+0x2158>
    4c02:	00001097          	auipc	ra,0x1
    4c06:	ae8080e7          	jalr	-1304(ra) # 56ea <open>
    4c0a:	8a2a                	mv	s4,a0
  total = 0;
    4c0c:	4981                	li	s3,0
  for(i = 0; ; i++){
    4c0e:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4c10:	00007917          	auipc	s2,0x7
    4c14:	f7090913          	addi	s2,s2,-144 # bb80 <buf>
  if(fd < 0){
    4c18:	06054e63          	bltz	a0,4c94 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4c1c:	12c00613          	li	a2,300
    4c20:	85ca                	mv	a1,s2
    4c22:	8552                	mv	a0,s4
    4c24:	00001097          	auipc	ra,0x1
    4c28:	a9e080e7          	jalr	-1378(ra) # 56c2 <read>
    if(cc < 0){
    4c2c:	08054263          	bltz	a0,4cb0 <bigfile+0x13a>
    if(cc == 0)
    4c30:	c971                	beqz	a0,4d04 <bigfile+0x18e>
    if(cc != SZ/2){
    4c32:	12c00793          	li	a5,300
    4c36:	08f51b63          	bne	a0,a5,4ccc <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4c3a:	01f4d79b          	srliw	a5,s1,0x1f
    4c3e:	9fa5                	addw	a5,a5,s1
    4c40:	4017d79b          	sraiw	a5,a5,0x1
    4c44:	00094703          	lbu	a4,0(s2)
    4c48:	0af71063          	bne	a4,a5,4ce8 <bigfile+0x172>
    4c4c:	12b94703          	lbu	a4,299(s2)
    4c50:	08f71c63          	bne	a4,a5,4ce8 <bigfile+0x172>
    total += cc;
    4c54:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4c58:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4c5a:	b7c9                	j	4c1c <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4c5c:	85d6                	mv	a1,s5
    4c5e:	00003517          	auipc	a0,0x3
    4c62:	fea50513          	addi	a0,a0,-22 # 7c48 <malloc+0x2168>
    4c66:	00001097          	auipc	ra,0x1
    4c6a:	dbc080e7          	jalr	-580(ra) # 5a22 <printf>
    exit(1);
    4c6e:	4505                	li	a0,1
    4c70:	00001097          	auipc	ra,0x1
    4c74:	a3a080e7          	jalr	-1478(ra) # 56aa <exit>
      printf("%s: write bigfile failed\n", s);
    4c78:	85d6                	mv	a1,s5
    4c7a:	00003517          	auipc	a0,0x3
    4c7e:	fee50513          	addi	a0,a0,-18 # 7c68 <malloc+0x2188>
    4c82:	00001097          	auipc	ra,0x1
    4c86:	da0080e7          	jalr	-608(ra) # 5a22 <printf>
      exit(1);
    4c8a:	4505                	li	a0,1
    4c8c:	00001097          	auipc	ra,0x1
    4c90:	a1e080e7          	jalr	-1506(ra) # 56aa <exit>
    printf("%s: cannot open bigfile\n", s);
    4c94:	85d6                	mv	a1,s5
    4c96:	00003517          	auipc	a0,0x3
    4c9a:	ff250513          	addi	a0,a0,-14 # 7c88 <malloc+0x21a8>
    4c9e:	00001097          	auipc	ra,0x1
    4ca2:	d84080e7          	jalr	-636(ra) # 5a22 <printf>
    exit(1);
    4ca6:	4505                	li	a0,1
    4ca8:	00001097          	auipc	ra,0x1
    4cac:	a02080e7          	jalr	-1534(ra) # 56aa <exit>
      printf("%s: read bigfile failed\n", s);
    4cb0:	85d6                	mv	a1,s5
    4cb2:	00003517          	auipc	a0,0x3
    4cb6:	ff650513          	addi	a0,a0,-10 # 7ca8 <malloc+0x21c8>
    4cba:	00001097          	auipc	ra,0x1
    4cbe:	d68080e7          	jalr	-664(ra) # 5a22 <printf>
      exit(1);
    4cc2:	4505                	li	a0,1
    4cc4:	00001097          	auipc	ra,0x1
    4cc8:	9e6080e7          	jalr	-1562(ra) # 56aa <exit>
      printf("%s: short read bigfile\n", s);
    4ccc:	85d6                	mv	a1,s5
    4cce:	00003517          	auipc	a0,0x3
    4cd2:	ffa50513          	addi	a0,a0,-6 # 7cc8 <malloc+0x21e8>
    4cd6:	00001097          	auipc	ra,0x1
    4cda:	d4c080e7          	jalr	-692(ra) # 5a22 <printf>
      exit(1);
    4cde:	4505                	li	a0,1
    4ce0:	00001097          	auipc	ra,0x1
    4ce4:	9ca080e7          	jalr	-1590(ra) # 56aa <exit>
      printf("%s: read bigfile wrong data\n", s);
    4ce8:	85d6                	mv	a1,s5
    4cea:	00003517          	auipc	a0,0x3
    4cee:	ff650513          	addi	a0,a0,-10 # 7ce0 <malloc+0x2200>
    4cf2:	00001097          	auipc	ra,0x1
    4cf6:	d30080e7          	jalr	-720(ra) # 5a22 <printf>
      exit(1);
    4cfa:	4505                	li	a0,1
    4cfc:	00001097          	auipc	ra,0x1
    4d00:	9ae080e7          	jalr	-1618(ra) # 56aa <exit>
  close(fd);
    4d04:	8552                	mv	a0,s4
    4d06:	00001097          	auipc	ra,0x1
    4d0a:	9cc080e7          	jalr	-1588(ra) # 56d2 <close>
  if(total != N*SZ){
    4d0e:	678d                	lui	a5,0x3
    4d10:	ee078793          	addi	a5,a5,-288 # 2ee0 <exitiputtest+0x46>
    4d14:	02f99363          	bne	s3,a5,4d3a <bigfile+0x1c4>
  unlink("bigfile.dat");
    4d18:	00003517          	auipc	a0,0x3
    4d1c:	f2050513          	addi	a0,a0,-224 # 7c38 <malloc+0x2158>
    4d20:	00001097          	auipc	ra,0x1
    4d24:	9da080e7          	jalr	-1574(ra) # 56fa <unlink>
}
    4d28:	70e2                	ld	ra,56(sp)
    4d2a:	7442                	ld	s0,48(sp)
    4d2c:	74a2                	ld	s1,40(sp)
    4d2e:	7902                	ld	s2,32(sp)
    4d30:	69e2                	ld	s3,24(sp)
    4d32:	6a42                	ld	s4,16(sp)
    4d34:	6aa2                	ld	s5,8(sp)
    4d36:	6121                	addi	sp,sp,64
    4d38:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4d3a:	85d6                	mv	a1,s5
    4d3c:	00003517          	auipc	a0,0x3
    4d40:	fc450513          	addi	a0,a0,-60 # 7d00 <malloc+0x2220>
    4d44:	00001097          	auipc	ra,0x1
    4d48:	cde080e7          	jalr	-802(ra) # 5a22 <printf>
    exit(1);
    4d4c:	4505                	li	a0,1
    4d4e:	00001097          	auipc	ra,0x1
    4d52:	95c080e7          	jalr	-1700(ra) # 56aa <exit>

0000000000004d56 <fsfull>:
{
    4d56:	7171                	addi	sp,sp,-176
    4d58:	f506                	sd	ra,168(sp)
    4d5a:	f122                	sd	s0,160(sp)
    4d5c:	ed26                	sd	s1,152(sp)
    4d5e:	e94a                	sd	s2,144(sp)
    4d60:	e54e                	sd	s3,136(sp)
    4d62:	e152                	sd	s4,128(sp)
    4d64:	fcd6                	sd	s5,120(sp)
    4d66:	f8da                	sd	s6,112(sp)
    4d68:	f4de                	sd	s7,104(sp)
    4d6a:	f0e2                	sd	s8,96(sp)
    4d6c:	ece6                	sd	s9,88(sp)
    4d6e:	e8ea                	sd	s10,80(sp)
    4d70:	e4ee                	sd	s11,72(sp)
    4d72:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4d74:	00003517          	auipc	a0,0x3
    4d78:	fac50513          	addi	a0,a0,-84 # 7d20 <malloc+0x2240>
    4d7c:	00001097          	auipc	ra,0x1
    4d80:	ca6080e7          	jalr	-858(ra) # 5a22 <printf>
  for(nfiles = 0; ; nfiles++){
    4d84:	4481                	li	s1,0
    name[0] = 'f';
    4d86:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4d8a:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4d8e:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4d92:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4d94:	00003c97          	auipc	s9,0x3
    4d98:	f9cc8c93          	addi	s9,s9,-100 # 7d30 <malloc+0x2250>
    int total = 0;
    4d9c:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4d9e:	00007a17          	auipc	s4,0x7
    4da2:	de2a0a13          	addi	s4,s4,-542 # bb80 <buf>
    name[0] = 'f';
    4da6:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4daa:	0384c7bb          	divw	a5,s1,s8
    4dae:	0307879b          	addiw	a5,a5,48
    4db2:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4db6:	0384e7bb          	remw	a5,s1,s8
    4dba:	0377c7bb          	divw	a5,a5,s7
    4dbe:	0307879b          	addiw	a5,a5,48
    4dc2:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4dc6:	0374e7bb          	remw	a5,s1,s7
    4dca:	0367c7bb          	divw	a5,a5,s6
    4dce:	0307879b          	addiw	a5,a5,48
    4dd2:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4dd6:	0364e7bb          	remw	a5,s1,s6
    4dda:	0307879b          	addiw	a5,a5,48
    4dde:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4de2:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4de6:	f5040593          	addi	a1,s0,-176
    4dea:	8566                	mv	a0,s9
    4dec:	00001097          	auipc	ra,0x1
    4df0:	c36080e7          	jalr	-970(ra) # 5a22 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4df4:	20200593          	li	a1,514
    4df8:	f5040513          	addi	a0,s0,-176
    4dfc:	00001097          	auipc	ra,0x1
    4e00:	8ee080e7          	jalr	-1810(ra) # 56ea <open>
    4e04:	892a                	mv	s2,a0
    if(fd < 0){
    4e06:	0a055663          	bgez	a0,4eb2 <fsfull+0x15c>
      printf("open %s failed\n", name);
    4e0a:	f5040593          	addi	a1,s0,-176
    4e0e:	00003517          	auipc	a0,0x3
    4e12:	f3250513          	addi	a0,a0,-206 # 7d40 <malloc+0x2260>
    4e16:	00001097          	auipc	ra,0x1
    4e1a:	c0c080e7          	jalr	-1012(ra) # 5a22 <printf>
  while(nfiles >= 0){
    4e1e:	0604c363          	bltz	s1,4e84 <fsfull+0x12e>
    name[0] = 'f';
    4e22:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4e26:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4e2a:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4e2e:	4929                	li	s2,10
  while(nfiles >= 0){
    4e30:	5afd                	li	s5,-1
    name[0] = 'f';
    4e32:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4e36:	0344c7bb          	divw	a5,s1,s4
    4e3a:	0307879b          	addiw	a5,a5,48
    4e3e:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4e42:	0344e7bb          	remw	a5,s1,s4
    4e46:	0337c7bb          	divw	a5,a5,s3
    4e4a:	0307879b          	addiw	a5,a5,48
    4e4e:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4e52:	0334e7bb          	remw	a5,s1,s3
    4e56:	0327c7bb          	divw	a5,a5,s2
    4e5a:	0307879b          	addiw	a5,a5,48
    4e5e:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4e62:	0324e7bb          	remw	a5,s1,s2
    4e66:	0307879b          	addiw	a5,a5,48
    4e6a:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4e6e:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4e72:	f5040513          	addi	a0,s0,-176
    4e76:	00001097          	auipc	ra,0x1
    4e7a:	884080e7          	jalr	-1916(ra) # 56fa <unlink>
    nfiles--;
    4e7e:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4e80:	fb5499e3          	bne	s1,s5,4e32 <fsfull+0xdc>
  printf("fsfull test finished\n");
    4e84:	00003517          	auipc	a0,0x3
    4e88:	edc50513          	addi	a0,a0,-292 # 7d60 <malloc+0x2280>
    4e8c:	00001097          	auipc	ra,0x1
    4e90:	b96080e7          	jalr	-1130(ra) # 5a22 <printf>
}
    4e94:	70aa                	ld	ra,168(sp)
    4e96:	740a                	ld	s0,160(sp)
    4e98:	64ea                	ld	s1,152(sp)
    4e9a:	694a                	ld	s2,144(sp)
    4e9c:	69aa                	ld	s3,136(sp)
    4e9e:	6a0a                	ld	s4,128(sp)
    4ea0:	7ae6                	ld	s5,120(sp)
    4ea2:	7b46                	ld	s6,112(sp)
    4ea4:	7ba6                	ld	s7,104(sp)
    4ea6:	7c06                	ld	s8,96(sp)
    4ea8:	6ce6                	ld	s9,88(sp)
    4eaa:	6d46                	ld	s10,80(sp)
    4eac:	6da6                	ld	s11,72(sp)
    4eae:	614d                	addi	sp,sp,176
    4eb0:	8082                	ret
    int total = 0;
    4eb2:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    4eb4:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4eb8:	40000613          	li	a2,1024
    4ebc:	85d2                	mv	a1,s4
    4ebe:	854a                	mv	a0,s2
    4ec0:	00001097          	auipc	ra,0x1
    4ec4:	80a080e7          	jalr	-2038(ra) # 56ca <write>
      if(cc < BSIZE)
    4ec8:	00aad563          	bge	s5,a0,4ed2 <fsfull+0x17c>
      total += cc;
    4ecc:	00a989bb          	addw	s3,s3,a0
    while(1){
    4ed0:	b7e5                	j	4eb8 <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    4ed2:	85ce                	mv	a1,s3
    4ed4:	00003517          	auipc	a0,0x3
    4ed8:	e7c50513          	addi	a0,a0,-388 # 7d50 <malloc+0x2270>
    4edc:	00001097          	auipc	ra,0x1
    4ee0:	b46080e7          	jalr	-1210(ra) # 5a22 <printf>
    close(fd);
    4ee4:	854a                	mv	a0,s2
    4ee6:	00000097          	auipc	ra,0x0
    4eea:	7ec080e7          	jalr	2028(ra) # 56d2 <close>
    if(total == 0)
    4eee:	f20988e3          	beqz	s3,4e1e <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    4ef2:	2485                	addiw	s1,s1,1
    4ef4:	bd4d                	j	4da6 <fsfull+0x50>

0000000000004ef6 <rand>:
{
    4ef6:	1141                	addi	sp,sp,-16
    4ef8:	e422                	sd	s0,8(sp)
    4efa:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    4efc:	00003717          	auipc	a4,0x3
    4f00:	45c70713          	addi	a4,a4,1116 # 8358 <randstate>
    4f04:	6308                	ld	a0,0(a4)
    4f06:	001967b7          	lui	a5,0x196
    4f0a:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x187a7d>
    4f0e:	02f50533          	mul	a0,a0,a5
    4f12:	3c6ef7b7          	lui	a5,0x3c6ef
    4f16:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e07cf>
    4f1a:	953e                	add	a0,a0,a5
    4f1c:	e308                	sd	a0,0(a4)
}
    4f1e:	2501                	sext.w	a0,a0
    4f20:	6422                	ld	s0,8(sp)
    4f22:	0141                	addi	sp,sp,16
    4f24:	8082                	ret

0000000000004f26 <badwrite>:
{
    4f26:	7179                	addi	sp,sp,-48
    4f28:	f406                	sd	ra,40(sp)
    4f2a:	f022                	sd	s0,32(sp)
    4f2c:	ec26                	sd	s1,24(sp)
    4f2e:	e84a                	sd	s2,16(sp)
    4f30:	e44e                	sd	s3,8(sp)
    4f32:	e052                	sd	s4,0(sp)
    4f34:	1800                	addi	s0,sp,48
  unlink("junk");
    4f36:	00003517          	auipc	a0,0x3
    4f3a:	e4250513          	addi	a0,a0,-446 # 7d78 <malloc+0x2298>
    4f3e:	00000097          	auipc	ra,0x0
    4f42:	7bc080e7          	jalr	1980(ra) # 56fa <unlink>
    4f46:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    4f4a:	00003997          	auipc	s3,0x3
    4f4e:	e2e98993          	addi	s3,s3,-466 # 7d78 <malloc+0x2298>
    write(fd, (char*)0xffffffffffL, 1);
    4f52:	5a7d                	li	s4,-1
    4f54:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    4f58:	20100593          	li	a1,513
    4f5c:	854e                	mv	a0,s3
    4f5e:	00000097          	auipc	ra,0x0
    4f62:	78c080e7          	jalr	1932(ra) # 56ea <open>
    4f66:	84aa                	mv	s1,a0
    if(fd < 0){
    4f68:	06054b63          	bltz	a0,4fde <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    4f6c:	4605                	li	a2,1
    4f6e:	85d2                	mv	a1,s4
    4f70:	00000097          	auipc	ra,0x0
    4f74:	75a080e7          	jalr	1882(ra) # 56ca <write>
    close(fd);
    4f78:	8526                	mv	a0,s1
    4f7a:	00000097          	auipc	ra,0x0
    4f7e:	758080e7          	jalr	1880(ra) # 56d2 <close>
    unlink("junk");
    4f82:	854e                	mv	a0,s3
    4f84:	00000097          	auipc	ra,0x0
    4f88:	776080e7          	jalr	1910(ra) # 56fa <unlink>
  for(int i = 0; i < assumed_free; i++){
    4f8c:	397d                	addiw	s2,s2,-1
    4f8e:	fc0915e3          	bnez	s2,4f58 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    4f92:	20100593          	li	a1,513
    4f96:	00003517          	auipc	a0,0x3
    4f9a:	de250513          	addi	a0,a0,-542 # 7d78 <malloc+0x2298>
    4f9e:	00000097          	auipc	ra,0x0
    4fa2:	74c080e7          	jalr	1868(ra) # 56ea <open>
    4fa6:	84aa                	mv	s1,a0
  if(fd < 0){
    4fa8:	04054863          	bltz	a0,4ff8 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    4fac:	4605                	li	a2,1
    4fae:	00001597          	auipc	a1,0x1
    4fb2:	ff258593          	addi	a1,a1,-14 # 5fa0 <malloc+0x4c0>
    4fb6:	00000097          	auipc	ra,0x0
    4fba:	714080e7          	jalr	1812(ra) # 56ca <write>
    4fbe:	4785                	li	a5,1
    4fc0:	04f50963          	beq	a0,a5,5012 <badwrite+0xec>
    printf("write failed\n");
    4fc4:	00003517          	auipc	a0,0x3
    4fc8:	dd450513          	addi	a0,a0,-556 # 7d98 <malloc+0x22b8>
    4fcc:	00001097          	auipc	ra,0x1
    4fd0:	a56080e7          	jalr	-1450(ra) # 5a22 <printf>
    exit(1);
    4fd4:	4505                	li	a0,1
    4fd6:	00000097          	auipc	ra,0x0
    4fda:	6d4080e7          	jalr	1748(ra) # 56aa <exit>
      printf("open junk failed\n");
    4fde:	00003517          	auipc	a0,0x3
    4fe2:	da250513          	addi	a0,a0,-606 # 7d80 <malloc+0x22a0>
    4fe6:	00001097          	auipc	ra,0x1
    4fea:	a3c080e7          	jalr	-1476(ra) # 5a22 <printf>
      exit(1);
    4fee:	4505                	li	a0,1
    4ff0:	00000097          	auipc	ra,0x0
    4ff4:	6ba080e7          	jalr	1722(ra) # 56aa <exit>
    printf("open junk failed\n");
    4ff8:	00003517          	auipc	a0,0x3
    4ffc:	d8850513          	addi	a0,a0,-632 # 7d80 <malloc+0x22a0>
    5000:	00001097          	auipc	ra,0x1
    5004:	a22080e7          	jalr	-1502(ra) # 5a22 <printf>
    exit(1);
    5008:	4505                	li	a0,1
    500a:	00000097          	auipc	ra,0x0
    500e:	6a0080e7          	jalr	1696(ra) # 56aa <exit>
  close(fd);
    5012:	8526                	mv	a0,s1
    5014:	00000097          	auipc	ra,0x0
    5018:	6be080e7          	jalr	1726(ra) # 56d2 <close>
  unlink("junk");
    501c:	00003517          	auipc	a0,0x3
    5020:	d5c50513          	addi	a0,a0,-676 # 7d78 <malloc+0x2298>
    5024:	00000097          	auipc	ra,0x0
    5028:	6d6080e7          	jalr	1750(ra) # 56fa <unlink>
  exit(0);
    502c:	4501                	li	a0,0
    502e:	00000097          	auipc	ra,0x0
    5032:	67c080e7          	jalr	1660(ra) # 56aa <exit>

0000000000005036 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    5036:	7139                	addi	sp,sp,-64
    5038:	fc06                	sd	ra,56(sp)
    503a:	f822                	sd	s0,48(sp)
    503c:	f426                	sd	s1,40(sp)
    503e:	f04a                	sd	s2,32(sp)
    5040:	ec4e                	sd	s3,24(sp)
    5042:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    5044:	fc840513          	addi	a0,s0,-56
    5048:	00000097          	auipc	ra,0x0
    504c:	672080e7          	jalr	1650(ra) # 56ba <pipe>
    5050:	06054863          	bltz	a0,50c0 <countfree+0x8a>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    5054:	00000097          	auipc	ra,0x0
    5058:	64e080e7          	jalr	1614(ra) # 56a2 <fork>

  if(pid < 0){
    505c:	06054f63          	bltz	a0,50da <countfree+0xa4>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    5060:	ed59                	bnez	a0,50fe <countfree+0xc8>
    close(fds[0]);
    5062:	fc842503          	lw	a0,-56(s0)
    5066:	00000097          	auipc	ra,0x0
    506a:	66c080e7          	jalr	1644(ra) # 56d2 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    506e:	54fd                	li	s1,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    5070:	4985                	li	s3,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    5072:	00001917          	auipc	s2,0x1
    5076:	f2e90913          	addi	s2,s2,-210 # 5fa0 <malloc+0x4c0>
      uint64 a = (uint64) sbrk(4096);
    507a:	6505                	lui	a0,0x1
    507c:	00000097          	auipc	ra,0x0
    5080:	6b6080e7          	jalr	1718(ra) # 5732 <sbrk>
      if(a == 0xffffffffffffffff){
    5084:	06950863          	beq	a0,s1,50f4 <countfree+0xbe>
      *(char *)(a + 4096 - 1) = 1;
    5088:	6785                	lui	a5,0x1
    508a:	953e                	add	a0,a0,a5
    508c:	ff350fa3          	sb	s3,-1(a0) # fff <bigdir+0x9d>
      if(write(fds[1], "x", 1) != 1){
    5090:	4605                	li	a2,1
    5092:	85ca                	mv	a1,s2
    5094:	fcc42503          	lw	a0,-52(s0)
    5098:	00000097          	auipc	ra,0x0
    509c:	632080e7          	jalr	1586(ra) # 56ca <write>
    50a0:	4785                	li	a5,1
    50a2:	fcf50ce3          	beq	a0,a5,507a <countfree+0x44>
        printf("write() failed in countfree()\n");
    50a6:	00003517          	auipc	a0,0x3
    50aa:	d4250513          	addi	a0,a0,-702 # 7de8 <malloc+0x2308>
    50ae:	00001097          	auipc	ra,0x1
    50b2:	974080e7          	jalr	-1676(ra) # 5a22 <printf>
        exit(1);
    50b6:	4505                	li	a0,1
    50b8:	00000097          	auipc	ra,0x0
    50bc:	5f2080e7          	jalr	1522(ra) # 56aa <exit>
    printf("pipe() failed in countfree()\n");
    50c0:	00003517          	auipc	a0,0x3
    50c4:	ce850513          	addi	a0,a0,-792 # 7da8 <malloc+0x22c8>
    50c8:	00001097          	auipc	ra,0x1
    50cc:	95a080e7          	jalr	-1702(ra) # 5a22 <printf>
    exit(1);
    50d0:	4505                	li	a0,1
    50d2:	00000097          	auipc	ra,0x0
    50d6:	5d8080e7          	jalr	1496(ra) # 56aa <exit>
    printf("fork failed in countfree()\n");
    50da:	00003517          	auipc	a0,0x3
    50de:	cee50513          	addi	a0,a0,-786 # 7dc8 <malloc+0x22e8>
    50e2:	00001097          	auipc	ra,0x1
    50e6:	940080e7          	jalr	-1728(ra) # 5a22 <printf>
    exit(1);
    50ea:	4505                	li	a0,1
    50ec:	00000097          	auipc	ra,0x0
    50f0:	5be080e7          	jalr	1470(ra) # 56aa <exit>
      }
    }

    exit(0);
    50f4:	4501                	li	a0,0
    50f6:	00000097          	auipc	ra,0x0
    50fa:	5b4080e7          	jalr	1460(ra) # 56aa <exit>
  }

  close(fds[1]);
    50fe:	fcc42503          	lw	a0,-52(s0)
    5102:	00000097          	auipc	ra,0x0
    5106:	5d0080e7          	jalr	1488(ra) # 56d2 <close>

  int n = 0;
    510a:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    510c:	4605                	li	a2,1
    510e:	fc740593          	addi	a1,s0,-57
    5112:	fc842503          	lw	a0,-56(s0)
    5116:	00000097          	auipc	ra,0x0
    511a:	5ac080e7          	jalr	1452(ra) # 56c2 <read>
    if(cc < 0){
    511e:	00054563          	bltz	a0,5128 <countfree+0xf2>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    5122:	c105                	beqz	a0,5142 <countfree+0x10c>
      break;
    n += 1;
    5124:	2485                	addiw	s1,s1,1
  while(1){
    5126:	b7dd                	j	510c <countfree+0xd6>
      printf("read() failed in countfree()\n");
    5128:	00003517          	auipc	a0,0x3
    512c:	ce050513          	addi	a0,a0,-800 # 7e08 <malloc+0x2328>
    5130:	00001097          	auipc	ra,0x1
    5134:	8f2080e7          	jalr	-1806(ra) # 5a22 <printf>
      exit(1);
    5138:	4505                	li	a0,1
    513a:	00000097          	auipc	ra,0x0
    513e:	570080e7          	jalr	1392(ra) # 56aa <exit>
  }

  close(fds[0]);
    5142:	fc842503          	lw	a0,-56(s0)
    5146:	00000097          	auipc	ra,0x0
    514a:	58c080e7          	jalr	1420(ra) # 56d2 <close>
  wait((int*)0);
    514e:	4501                	li	a0,0
    5150:	00000097          	auipc	ra,0x0
    5154:	562080e7          	jalr	1378(ra) # 56b2 <wait>
  
  return n;
}
    5158:	8526                	mv	a0,s1
    515a:	70e2                	ld	ra,56(sp)
    515c:	7442                	ld	s0,48(sp)
    515e:	74a2                	ld	s1,40(sp)
    5160:	7902                	ld	s2,32(sp)
    5162:	69e2                	ld	s3,24(sp)
    5164:	6121                	addi	sp,sp,64
    5166:	8082                	ret

0000000000005168 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5168:	7179                	addi	sp,sp,-48
    516a:	f406                	sd	ra,40(sp)
    516c:	f022                	sd	s0,32(sp)
    516e:	ec26                	sd	s1,24(sp)
    5170:	e84a                	sd	s2,16(sp)
    5172:	1800                	addi	s0,sp,48
    5174:	84aa                	mv	s1,a0
    5176:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5178:	00003517          	auipc	a0,0x3
    517c:	cb050513          	addi	a0,a0,-848 # 7e28 <malloc+0x2348>
    5180:	00001097          	auipc	ra,0x1
    5184:	8a2080e7          	jalr	-1886(ra) # 5a22 <printf>
  if((pid = fork()) < 0) {
    5188:	00000097          	auipc	ra,0x0
    518c:	51a080e7          	jalr	1306(ra) # 56a2 <fork>
    5190:	02054e63          	bltz	a0,51cc <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5194:	c929                	beqz	a0,51e6 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    5196:	fdc40513          	addi	a0,s0,-36
    519a:	00000097          	auipc	ra,0x0
    519e:	518080e7          	jalr	1304(ra) # 56b2 <wait>
    if(xstatus != 0) 
    51a2:	fdc42783          	lw	a5,-36(s0)
    51a6:	c7b9                	beqz	a5,51f4 <run+0x8c>
      printf("FAILED\n");
    51a8:	00003517          	auipc	a0,0x3
    51ac:	ca850513          	addi	a0,a0,-856 # 7e50 <malloc+0x2370>
    51b0:	00001097          	auipc	ra,0x1
    51b4:	872080e7          	jalr	-1934(ra) # 5a22 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    51b8:	fdc42503          	lw	a0,-36(s0)
  }
}
    51bc:	00153513          	seqz	a0,a0
    51c0:	70a2                	ld	ra,40(sp)
    51c2:	7402                	ld	s0,32(sp)
    51c4:	64e2                	ld	s1,24(sp)
    51c6:	6942                	ld	s2,16(sp)
    51c8:	6145                	addi	sp,sp,48
    51ca:	8082                	ret
    printf("runtest: fork error\n");
    51cc:	00003517          	auipc	a0,0x3
    51d0:	c6c50513          	addi	a0,a0,-916 # 7e38 <malloc+0x2358>
    51d4:	00001097          	auipc	ra,0x1
    51d8:	84e080e7          	jalr	-1970(ra) # 5a22 <printf>
    exit(1);
    51dc:	4505                	li	a0,1
    51de:	00000097          	auipc	ra,0x0
    51e2:	4cc080e7          	jalr	1228(ra) # 56aa <exit>
    f(s);
    51e6:	854a                	mv	a0,s2
    51e8:	9482                	jalr	s1
    exit(0);
    51ea:	4501                	li	a0,0
    51ec:	00000097          	auipc	ra,0x0
    51f0:	4be080e7          	jalr	1214(ra) # 56aa <exit>
      printf("OK\n");
    51f4:	00003517          	auipc	a0,0x3
    51f8:	c6450513          	addi	a0,a0,-924 # 7e58 <malloc+0x2378>
    51fc:	00001097          	auipc	ra,0x1
    5200:	826080e7          	jalr	-2010(ra) # 5a22 <printf>
    5204:	bf55                	j	51b8 <run+0x50>

0000000000005206 <main>:

int
main(int argc, char *argv[])
{
    5206:	c0010113          	addi	sp,sp,-1024
    520a:	3e113c23          	sd	ra,1016(sp)
    520e:	3e813823          	sd	s0,1008(sp)
    5212:	3e913423          	sd	s1,1000(sp)
    5216:	3f213023          	sd	s2,992(sp)
    521a:	3d313c23          	sd	s3,984(sp)
    521e:	3d413823          	sd	s4,976(sp)
    5222:	3d513423          	sd	s5,968(sp)
    5226:	3d613023          	sd	s6,960(sp)
    522a:	40010413          	addi	s0,sp,1024
    522e:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5230:	4789                	li	a5,2
    5232:	08f50763          	beq	a0,a5,52c0 <main+0xba>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5236:	4785                	li	a5,1
  char *justone = 0;
    5238:	4901                	li	s2,0
  } else if(argc > 1){
    523a:	0ca7c163          	blt	a5,a0,52fc <main+0xf6>
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    523e:	00003797          	auipc	a5,0x3
    5242:	d3278793          	addi	a5,a5,-718 # 7f70 <malloc+0x2490>
    5246:	c0040713          	addi	a4,s0,-1024
    524a:	00003817          	auipc	a6,0x3
    524e:	0e680813          	addi	a6,a6,230 # 8330 <malloc+0x2850>
    5252:	6388                	ld	a0,0(a5)
    5254:	678c                	ld	a1,8(a5)
    5256:	6b90                	ld	a2,16(a5)
    5258:	6f94                	ld	a3,24(a5)
    525a:	e308                	sd	a0,0(a4)
    525c:	e70c                	sd	a1,8(a4)
    525e:	eb10                	sd	a2,16(a4)
    5260:	ef14                	sd	a3,24(a4)
    5262:	02078793          	addi	a5,a5,32
    5266:	02070713          	addi	a4,a4,32
    526a:	ff0794e3          	bne	a5,a6,5252 <main+0x4c>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    526e:	00003517          	auipc	a0,0x3
    5272:	ca250513          	addi	a0,a0,-862 # 7f10 <malloc+0x2430>
    5276:	00000097          	auipc	ra,0x0
    527a:	7ac080e7          	jalr	1964(ra) # 5a22 <printf>
  int free0 = countfree();
    527e:	00000097          	auipc	ra,0x0
    5282:	db8080e7          	jalr	-584(ra) # 5036 <countfree>
    5286:	8a2a                	mv	s4,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    5288:	c0843503          	ld	a0,-1016(s0)
    528c:	c0040493          	addi	s1,s0,-1024
  int fail = 0;
    5290:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    5292:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    5294:	e55d                	bnez	a0,5342 <main+0x13c>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    5296:	00000097          	auipc	ra,0x0
    529a:	da0080e7          	jalr	-608(ra) # 5036 <countfree>
    529e:	85aa                	mv	a1,a0
    52a0:	0f455163          	bge	a0,s4,5382 <main+0x17c>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    52a4:	8652                	mv	a2,s4
    52a6:	00003517          	auipc	a0,0x3
    52aa:	c2250513          	addi	a0,a0,-990 # 7ec8 <malloc+0x23e8>
    52ae:	00000097          	auipc	ra,0x0
    52b2:	774080e7          	jalr	1908(ra) # 5a22 <printf>
    exit(1);
    52b6:	4505                	li	a0,1
    52b8:	00000097          	auipc	ra,0x0
    52bc:	3f2080e7          	jalr	1010(ra) # 56aa <exit>
    52c0:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    52c2:	00003597          	auipc	a1,0x3
    52c6:	b9e58593          	addi	a1,a1,-1122 # 7e60 <malloc+0x2380>
    52ca:	6488                	ld	a0,8(s1)
    52cc:	00000097          	auipc	ra,0x0
    52d0:	184080e7          	jalr	388(ra) # 5450 <strcmp>
    52d4:	10050563          	beqz	a0,53de <main+0x1d8>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    52d8:	00003597          	auipc	a1,0x3
    52dc:	c7058593          	addi	a1,a1,-912 # 7f48 <malloc+0x2468>
    52e0:	6488                	ld	a0,8(s1)
    52e2:	00000097          	auipc	ra,0x0
    52e6:	16e080e7          	jalr	366(ra) # 5450 <strcmp>
    52ea:	c97d                	beqz	a0,53e0 <main+0x1da>
  } else if(argc == 2 && argv[1][0] != '-'){
    52ec:	0084b903          	ld	s2,8(s1)
    52f0:	00094703          	lbu	a4,0(s2)
    52f4:	02d00793          	li	a5,45
    52f8:	f4f713e3          	bne	a4,a5,523e <main+0x38>
    printf("Usage: usertests [-c] [testname]\n");
    52fc:	00003517          	auipc	a0,0x3
    5300:	b6c50513          	addi	a0,a0,-1172 # 7e68 <malloc+0x2388>
    5304:	00000097          	auipc	ra,0x0
    5308:	71e080e7          	jalr	1822(ra) # 5a22 <printf>
    exit(1);
    530c:	4505                	li	a0,1
    530e:	00000097          	auipc	ra,0x0
    5312:	39c080e7          	jalr	924(ra) # 56aa <exit>
          exit(1);
    5316:	4505                	li	a0,1
    5318:	00000097          	auipc	ra,0x0
    531c:	392080e7          	jalr	914(ra) # 56aa <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5320:	40a905bb          	subw	a1,s2,a0
    5324:	855a                	mv	a0,s6
    5326:	00000097          	auipc	ra,0x0
    532a:	6fc080e7          	jalr	1788(ra) # 5a22 <printf>
        if(continuous != 2)
    532e:	09498463          	beq	s3,s4,53b6 <main+0x1b0>
          exit(1);
    5332:	4505                	li	a0,1
    5334:	00000097          	auipc	ra,0x0
    5338:	376080e7          	jalr	886(ra) # 56aa <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    533c:	04c1                	addi	s1,s1,16
    533e:	6488                	ld	a0,8(s1)
    5340:	c115                	beqz	a0,5364 <main+0x15e>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    5342:	00090863          	beqz	s2,5352 <main+0x14c>
    5346:	85ca                	mv	a1,s2
    5348:	00000097          	auipc	ra,0x0
    534c:	108080e7          	jalr	264(ra) # 5450 <strcmp>
    5350:	f575                	bnez	a0,533c <main+0x136>
      if(!run(t->f, t->s))
    5352:	648c                	ld	a1,8(s1)
    5354:	6088                	ld	a0,0(s1)
    5356:	00000097          	auipc	ra,0x0
    535a:	e12080e7          	jalr	-494(ra) # 5168 <run>
    535e:	fd79                	bnez	a0,533c <main+0x136>
        fail = 1;
    5360:	89d6                	mv	s3,s5
    5362:	bfe9                	j	533c <main+0x136>
  if(fail){
    5364:	f20989e3          	beqz	s3,5296 <main+0x90>
    printf("SOME TESTS FAILED\n");
    5368:	00003517          	auipc	a0,0x3
    536c:	b4850513          	addi	a0,a0,-1208 # 7eb0 <malloc+0x23d0>
    5370:	00000097          	auipc	ra,0x0
    5374:	6b2080e7          	jalr	1714(ra) # 5a22 <printf>
    exit(1);
    5378:	4505                	li	a0,1
    537a:	00000097          	auipc	ra,0x0
    537e:	330080e7          	jalr	816(ra) # 56aa <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    5382:	00003517          	auipc	a0,0x3
    5386:	b7650513          	addi	a0,a0,-1162 # 7ef8 <malloc+0x2418>
    538a:	00000097          	auipc	ra,0x0
    538e:	698080e7          	jalr	1688(ra) # 5a22 <printf>
    exit(0);
    5392:	4501                	li	a0,0
    5394:	00000097          	auipc	ra,0x0
    5398:	316080e7          	jalr	790(ra) # 56aa <exit>
        printf("SOME TESTS FAILED\n");
    539c:	8556                	mv	a0,s5
    539e:	00000097          	auipc	ra,0x0
    53a2:	684080e7          	jalr	1668(ra) # 5a22 <printf>
        if(continuous != 2)
    53a6:	f74998e3          	bne	s3,s4,5316 <main+0x110>
      int free1 = countfree();
    53aa:	00000097          	auipc	ra,0x0
    53ae:	c8c080e7          	jalr	-884(ra) # 5036 <countfree>
      if(free1 < free0){
    53b2:	f72547e3          	blt	a0,s2,5320 <main+0x11a>
      int free0 = countfree();
    53b6:	00000097          	auipc	ra,0x0
    53ba:	c80080e7          	jalr	-896(ra) # 5036 <countfree>
    53be:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    53c0:	c0843583          	ld	a1,-1016(s0)
    53c4:	d1fd                	beqz	a1,53aa <main+0x1a4>
    53c6:	c0040493          	addi	s1,s0,-1024
        if(!run(t->f, t->s)){
    53ca:	6088                	ld	a0,0(s1)
    53cc:	00000097          	auipc	ra,0x0
    53d0:	d9c080e7          	jalr	-612(ra) # 5168 <run>
    53d4:	d561                	beqz	a0,539c <main+0x196>
      for (struct test *t = tests; t->s != 0; t++) {
    53d6:	04c1                	addi	s1,s1,16
    53d8:	648c                	ld	a1,8(s1)
    53da:	f9e5                	bnez	a1,53ca <main+0x1c4>
    53dc:	b7f9                	j	53aa <main+0x1a4>
    continuous = 1;
    53de:	4985                	li	s3,1
  } tests[] = {
    53e0:	00003797          	auipc	a5,0x3
    53e4:	b9078793          	addi	a5,a5,-1136 # 7f70 <malloc+0x2490>
    53e8:	c0040713          	addi	a4,s0,-1024
    53ec:	00003817          	auipc	a6,0x3
    53f0:	f4480813          	addi	a6,a6,-188 # 8330 <malloc+0x2850>
    53f4:	6388                	ld	a0,0(a5)
    53f6:	678c                	ld	a1,8(a5)
    53f8:	6b90                	ld	a2,16(a5)
    53fa:	6f94                	ld	a3,24(a5)
    53fc:	e308                	sd	a0,0(a4)
    53fe:	e70c                	sd	a1,8(a4)
    5400:	eb10                	sd	a2,16(a4)
    5402:	ef14                	sd	a3,24(a4)
    5404:	02078793          	addi	a5,a5,32
    5408:	02070713          	addi	a4,a4,32
    540c:	ff0794e3          	bne	a5,a6,53f4 <main+0x1ee>
    printf("continuous usertests starting\n");
    5410:	00003517          	auipc	a0,0x3
    5414:	b1850513          	addi	a0,a0,-1256 # 7f28 <malloc+0x2448>
    5418:	00000097          	auipc	ra,0x0
    541c:	60a080e7          	jalr	1546(ra) # 5a22 <printf>
        printf("SOME TESTS FAILED\n");
    5420:	00003a97          	auipc	s5,0x3
    5424:	a90a8a93          	addi	s5,s5,-1392 # 7eb0 <malloc+0x23d0>
        if(continuous != 2)
    5428:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    542a:	00003b17          	auipc	s6,0x3
    542e:	a66b0b13          	addi	s6,s6,-1434 # 7e90 <malloc+0x23b0>
    5432:	b751                	j	53b6 <main+0x1b0>

0000000000005434 <strcpy>:
#include "include/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    5434:	1141                	addi	sp,sp,-16
    5436:	e422                	sd	s0,8(sp)
    5438:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    543a:	87aa                	mv	a5,a0
    543c:	0585                	addi	a1,a1,1
    543e:	0785                	addi	a5,a5,1
    5440:	fff5c703          	lbu	a4,-1(a1)
    5444:	fee78fa3          	sb	a4,-1(a5)
    5448:	fb75                	bnez	a4,543c <strcpy+0x8>
    ;
  return os;
}
    544a:	6422                	ld	s0,8(sp)
    544c:	0141                	addi	sp,sp,16
    544e:	8082                	ret

0000000000005450 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5450:	1141                	addi	sp,sp,-16
    5452:	e422                	sd	s0,8(sp)
    5454:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5456:	00054783          	lbu	a5,0(a0)
    545a:	cb91                	beqz	a5,546e <strcmp+0x1e>
    545c:	0005c703          	lbu	a4,0(a1)
    5460:	00f71763          	bne	a4,a5,546e <strcmp+0x1e>
    p++, q++;
    5464:	0505                	addi	a0,a0,1
    5466:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5468:	00054783          	lbu	a5,0(a0)
    546c:	fbe5                	bnez	a5,545c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    546e:	0005c503          	lbu	a0,0(a1)
}
    5472:	40a7853b          	subw	a0,a5,a0
    5476:	6422                	ld	s0,8(sp)
    5478:	0141                	addi	sp,sp,16
    547a:	8082                	ret

000000000000547c <strlen>:

uint
strlen(const char *s)
{
    547c:	1141                	addi	sp,sp,-16
    547e:	e422                	sd	s0,8(sp)
    5480:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5482:	00054783          	lbu	a5,0(a0)
    5486:	cf91                	beqz	a5,54a2 <strlen+0x26>
    5488:	0505                	addi	a0,a0,1
    548a:	87aa                	mv	a5,a0
    548c:	4685                	li	a3,1
    548e:	9e89                	subw	a3,a3,a0
    5490:	00f6853b          	addw	a0,a3,a5
    5494:	0785                	addi	a5,a5,1
    5496:	fff7c703          	lbu	a4,-1(a5)
    549a:	fb7d                	bnez	a4,5490 <strlen+0x14>
    ;
  return n;
}
    549c:	6422                	ld	s0,8(sp)
    549e:	0141                	addi	sp,sp,16
    54a0:	8082                	ret
  for(n = 0; s[n]; n++)
    54a2:	4501                	li	a0,0
    54a4:	bfe5                	j	549c <strlen+0x20>

00000000000054a6 <memset>:

void*
memset(void *dst, int c, uint n)
{
    54a6:	1141                	addi	sp,sp,-16
    54a8:	e422                	sd	s0,8(sp)
    54aa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    54ac:	ce09                	beqz	a2,54c6 <memset+0x20>
    54ae:	87aa                	mv	a5,a0
    54b0:	fff6071b          	addiw	a4,a2,-1
    54b4:	1702                	slli	a4,a4,0x20
    54b6:	9301                	srli	a4,a4,0x20
    54b8:	0705                	addi	a4,a4,1
    54ba:	972a                	add	a4,a4,a0
    cdst[i] = c;
    54bc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    54c0:	0785                	addi	a5,a5,1
    54c2:	fee79de3          	bne	a5,a4,54bc <memset+0x16>
  }
  return dst;
}
    54c6:	6422                	ld	s0,8(sp)
    54c8:	0141                	addi	sp,sp,16
    54ca:	8082                	ret

00000000000054cc <strchr>:

char*
strchr(const char *s, char c)
{
    54cc:	1141                	addi	sp,sp,-16
    54ce:	e422                	sd	s0,8(sp)
    54d0:	0800                	addi	s0,sp,16
  for(; *s; s++)
    54d2:	00054783          	lbu	a5,0(a0)
    54d6:	cb99                	beqz	a5,54ec <strchr+0x20>
    if(*s == c)
    54d8:	00f58763          	beq	a1,a5,54e6 <strchr+0x1a>
  for(; *s; s++)
    54dc:	0505                	addi	a0,a0,1
    54de:	00054783          	lbu	a5,0(a0)
    54e2:	fbfd                	bnez	a5,54d8 <strchr+0xc>
      return (char*)s;
  return 0;
    54e4:	4501                	li	a0,0
}
    54e6:	6422                	ld	s0,8(sp)
    54e8:	0141                	addi	sp,sp,16
    54ea:	8082                	ret
  return 0;
    54ec:	4501                	li	a0,0
    54ee:	bfe5                	j	54e6 <strchr+0x1a>

00000000000054f0 <gets>:

char*
gets(char *buf, int max)
{
    54f0:	711d                	addi	sp,sp,-96
    54f2:	ec86                	sd	ra,88(sp)
    54f4:	e8a2                	sd	s0,80(sp)
    54f6:	e4a6                	sd	s1,72(sp)
    54f8:	e0ca                	sd	s2,64(sp)
    54fa:	fc4e                	sd	s3,56(sp)
    54fc:	f852                	sd	s4,48(sp)
    54fe:	f456                	sd	s5,40(sp)
    5500:	f05a                	sd	s6,32(sp)
    5502:	ec5e                	sd	s7,24(sp)
    5504:	1080                	addi	s0,sp,96
    5506:	8baa                	mv	s7,a0
    5508:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    550a:	892a                	mv	s2,a0
    550c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    550e:	4aa9                	li	s5,10
    5510:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5512:	89a6                	mv	s3,s1
    5514:	2485                	addiw	s1,s1,1
    5516:	0344d863          	bge	s1,s4,5546 <gets+0x56>
    cc = read(0, &c, 1);
    551a:	4605                	li	a2,1
    551c:	faf40593          	addi	a1,s0,-81
    5520:	4501                	li	a0,0
    5522:	00000097          	auipc	ra,0x0
    5526:	1a0080e7          	jalr	416(ra) # 56c2 <read>
    if(cc < 1)
    552a:	00a05e63          	blez	a0,5546 <gets+0x56>
    buf[i++] = c;
    552e:	faf44783          	lbu	a5,-81(s0)
    5532:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5536:	01578763          	beq	a5,s5,5544 <gets+0x54>
    553a:	0905                	addi	s2,s2,1
    553c:	fd679be3          	bne	a5,s6,5512 <gets+0x22>
  for(i=0; i+1 < max; ){
    5540:	89a6                	mv	s3,s1
    5542:	a011                	j	5546 <gets+0x56>
    5544:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5546:	99de                	add	s3,s3,s7
    5548:	00098023          	sb	zero,0(s3)
  return buf;
}
    554c:	855e                	mv	a0,s7
    554e:	60e6                	ld	ra,88(sp)
    5550:	6446                	ld	s0,80(sp)
    5552:	64a6                	ld	s1,72(sp)
    5554:	6906                	ld	s2,64(sp)
    5556:	79e2                	ld	s3,56(sp)
    5558:	7a42                	ld	s4,48(sp)
    555a:	7aa2                	ld	s5,40(sp)
    555c:	7b02                	ld	s6,32(sp)
    555e:	6be2                	ld	s7,24(sp)
    5560:	6125                	addi	sp,sp,96
    5562:	8082                	ret

0000000000005564 <stat>:

int
stat(const char *n, struct stat *st)
{
    5564:	1101                	addi	sp,sp,-32
    5566:	ec06                	sd	ra,24(sp)
    5568:	e822                	sd	s0,16(sp)
    556a:	e426                	sd	s1,8(sp)
    556c:	e04a                	sd	s2,0(sp)
    556e:	1000                	addi	s0,sp,32
    5570:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5572:	4581                	li	a1,0
    5574:	00000097          	auipc	ra,0x0
    5578:	176080e7          	jalr	374(ra) # 56ea <open>
  if(fd < 0)
    557c:	02054563          	bltz	a0,55a6 <stat+0x42>
    5580:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5582:	85ca                	mv	a1,s2
    5584:	00000097          	auipc	ra,0x0
    5588:	17e080e7          	jalr	382(ra) # 5702 <fstat>
    558c:	892a                	mv	s2,a0
  close(fd);
    558e:	8526                	mv	a0,s1
    5590:	00000097          	auipc	ra,0x0
    5594:	142080e7          	jalr	322(ra) # 56d2 <close>
  return r;
}
    5598:	854a                	mv	a0,s2
    559a:	60e2                	ld	ra,24(sp)
    559c:	6442                	ld	s0,16(sp)
    559e:	64a2                	ld	s1,8(sp)
    55a0:	6902                	ld	s2,0(sp)
    55a2:	6105                	addi	sp,sp,32
    55a4:	8082                	ret
    return -1;
    55a6:	597d                	li	s2,-1
    55a8:	bfc5                	j	5598 <stat+0x34>

00000000000055aa <atoi>:

int
atoi(const char *s)
{
    55aa:	1141                	addi	sp,sp,-16
    55ac:	e422                	sd	s0,8(sp)
    55ae:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    55b0:	00054603          	lbu	a2,0(a0)
    55b4:	fd06079b          	addiw	a5,a2,-48
    55b8:	0ff7f793          	andi	a5,a5,255
    55bc:	4725                	li	a4,9
    55be:	02f76963          	bltu	a4,a5,55f0 <atoi+0x46>
    55c2:	86aa                	mv	a3,a0
  n = 0;
    55c4:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    55c6:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    55c8:	0685                	addi	a3,a3,1
    55ca:	0025179b          	slliw	a5,a0,0x2
    55ce:	9fa9                	addw	a5,a5,a0
    55d0:	0017979b          	slliw	a5,a5,0x1
    55d4:	9fb1                	addw	a5,a5,a2
    55d6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    55da:	0006c603          	lbu	a2,0(a3) # 1000 <bigdir+0x9e>
    55de:	fd06071b          	addiw	a4,a2,-48
    55e2:	0ff77713          	andi	a4,a4,255
    55e6:	fee5f1e3          	bgeu	a1,a4,55c8 <atoi+0x1e>
  return n;
}
    55ea:	6422                	ld	s0,8(sp)
    55ec:	0141                	addi	sp,sp,16
    55ee:	8082                	ret
  n = 0;
    55f0:	4501                	li	a0,0
    55f2:	bfe5                	j	55ea <atoi+0x40>

00000000000055f4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    55f4:	1141                	addi	sp,sp,-16
    55f6:	e422                	sd	s0,8(sp)
    55f8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    55fa:	02b57663          	bgeu	a0,a1,5626 <memmove+0x32>
    while(n-- > 0)
    55fe:	02c05163          	blez	a2,5620 <memmove+0x2c>
    5602:	fff6079b          	addiw	a5,a2,-1
    5606:	1782                	slli	a5,a5,0x20
    5608:	9381                	srli	a5,a5,0x20
    560a:	0785                	addi	a5,a5,1
    560c:	97aa                	add	a5,a5,a0
  dst = vdst;
    560e:	872a                	mv	a4,a0
      *dst++ = *src++;
    5610:	0585                	addi	a1,a1,1
    5612:	0705                	addi	a4,a4,1
    5614:	fff5c683          	lbu	a3,-1(a1)
    5618:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    561c:	fee79ae3          	bne	a5,a4,5610 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5620:	6422                	ld	s0,8(sp)
    5622:	0141                	addi	sp,sp,16
    5624:	8082                	ret
    dst += n;
    5626:	00c50733          	add	a4,a0,a2
    src += n;
    562a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    562c:	fec05ae3          	blez	a2,5620 <memmove+0x2c>
    5630:	fff6079b          	addiw	a5,a2,-1
    5634:	1782                	slli	a5,a5,0x20
    5636:	9381                	srli	a5,a5,0x20
    5638:	fff7c793          	not	a5,a5
    563c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    563e:	15fd                	addi	a1,a1,-1
    5640:	177d                	addi	a4,a4,-1
    5642:	0005c683          	lbu	a3,0(a1)
    5646:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    564a:	fee79ae3          	bne	a5,a4,563e <memmove+0x4a>
    564e:	bfc9                	j	5620 <memmove+0x2c>

0000000000005650 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5650:	1141                	addi	sp,sp,-16
    5652:	e422                	sd	s0,8(sp)
    5654:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5656:	ca05                	beqz	a2,5686 <memcmp+0x36>
    5658:	fff6069b          	addiw	a3,a2,-1
    565c:	1682                	slli	a3,a3,0x20
    565e:	9281                	srli	a3,a3,0x20
    5660:	0685                	addi	a3,a3,1
    5662:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5664:	00054783          	lbu	a5,0(a0)
    5668:	0005c703          	lbu	a4,0(a1)
    566c:	00e79863          	bne	a5,a4,567c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5670:	0505                	addi	a0,a0,1
    p2++;
    5672:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5674:	fed518e3          	bne	a0,a3,5664 <memcmp+0x14>
  }
  return 0;
    5678:	4501                	li	a0,0
    567a:	a019                	j	5680 <memcmp+0x30>
      return *p1 - *p2;
    567c:	40e7853b          	subw	a0,a5,a4
}
    5680:	6422                	ld	s0,8(sp)
    5682:	0141                	addi	sp,sp,16
    5684:	8082                	ret
  return 0;
    5686:	4501                	li	a0,0
    5688:	bfe5                	j	5680 <memcmp+0x30>

000000000000568a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    568a:	1141                	addi	sp,sp,-16
    568c:	e406                	sd	ra,8(sp)
    568e:	e022                	sd	s0,0(sp)
    5690:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5692:	00000097          	auipc	ra,0x0
    5696:	f62080e7          	jalr	-158(ra) # 55f4 <memmove>
}
    569a:	60a2                	ld	ra,8(sp)
    569c:	6402                	ld	s0,0(sp)
    569e:	0141                	addi	sp,sp,16
    56a0:	8082                	ret

00000000000056a2 <fork>:
# generated by usys.pl - do not edit
#include "include/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    56a2:	4885                	li	a7,1
 ecall
    56a4:	00000073          	ecall
 ret
    56a8:	8082                	ret

00000000000056aa <exit>:
.global exit
exit:
 li a7, SYS_exit
    56aa:	4889                	li	a7,2
 ecall
    56ac:	00000073          	ecall
 ret
    56b0:	8082                	ret

00000000000056b2 <wait>:
.global wait
wait:
 li a7, SYS_wait
    56b2:	488d                	li	a7,3
 ecall
    56b4:	00000073          	ecall
 ret
    56b8:	8082                	ret

00000000000056ba <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    56ba:	4891                	li	a7,4
 ecall
    56bc:	00000073          	ecall
 ret
    56c0:	8082                	ret

00000000000056c2 <read>:
.global read
read:
 li a7, SYS_read
    56c2:	4895                	li	a7,5
 ecall
    56c4:	00000073          	ecall
 ret
    56c8:	8082                	ret

00000000000056ca <write>:
.global write
write:
 li a7, SYS_write
    56ca:	48c1                	li	a7,16
 ecall
    56cc:	00000073          	ecall
 ret
    56d0:	8082                	ret

00000000000056d2 <close>:
.global close
close:
 li a7, SYS_close
    56d2:	48d5                	li	a7,21
 ecall
    56d4:	00000073          	ecall
 ret
    56d8:	8082                	ret

00000000000056da <kill>:
.global kill
kill:
 li a7, SYS_kill
    56da:	4899                	li	a7,6
 ecall
    56dc:	00000073          	ecall
 ret
    56e0:	8082                	ret

00000000000056e2 <exec>:
.global exec
exec:
 li a7, SYS_exec
    56e2:	489d                	li	a7,7
 ecall
    56e4:	00000073          	ecall
 ret
    56e8:	8082                	ret

00000000000056ea <open>:
.global open
open:
 li a7, SYS_open
    56ea:	48bd                	li	a7,15
 ecall
    56ec:	00000073          	ecall
 ret
    56f0:	8082                	ret

00000000000056f2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    56f2:	48c5                	li	a7,17
 ecall
    56f4:	00000073          	ecall
 ret
    56f8:	8082                	ret

00000000000056fa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    56fa:	48c9                	li	a7,18
 ecall
    56fc:	00000073          	ecall
 ret
    5700:	8082                	ret

0000000000005702 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5702:	48a1                	li	a7,8
 ecall
    5704:	00000073          	ecall
 ret
    5708:	8082                	ret

000000000000570a <link>:
.global link
link:
 li a7, SYS_link
    570a:	48cd                	li	a7,19
 ecall
    570c:	00000073          	ecall
 ret
    5710:	8082                	ret

0000000000005712 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5712:	48d1                	li	a7,20
 ecall
    5714:	00000073          	ecall
 ret
    5718:	8082                	ret

000000000000571a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    571a:	48a5                	li	a7,9
 ecall
    571c:	00000073          	ecall
 ret
    5720:	8082                	ret

0000000000005722 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5722:	48a9                	li	a7,10
 ecall
    5724:	00000073          	ecall
 ret
    5728:	8082                	ret

000000000000572a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    572a:	48ad                	li	a7,11
 ecall
    572c:	00000073          	ecall
 ret
    5730:	8082                	ret

0000000000005732 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5732:	48b1                	li	a7,12
 ecall
    5734:	00000073          	ecall
 ret
    5738:	8082                	ret

000000000000573a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    573a:	48b5                	li	a7,13
 ecall
    573c:	00000073          	ecall
 ret
    5740:	8082                	ret

0000000000005742 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5742:	48b9                	li	a7,14
 ecall
    5744:	00000073          	ecall
 ret
    5748:	8082                	ret

000000000000574a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    574a:	1101                	addi	sp,sp,-32
    574c:	ec06                	sd	ra,24(sp)
    574e:	e822                	sd	s0,16(sp)
    5750:	1000                	addi	s0,sp,32
    5752:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5756:	4605                	li	a2,1
    5758:	fef40593          	addi	a1,s0,-17
    575c:	00000097          	auipc	ra,0x0
    5760:	f6e080e7          	jalr	-146(ra) # 56ca <write>
}
    5764:	60e2                	ld	ra,24(sp)
    5766:	6442                	ld	s0,16(sp)
    5768:	6105                	addi	sp,sp,32
    576a:	8082                	ret

000000000000576c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    576c:	7139                	addi	sp,sp,-64
    576e:	fc06                	sd	ra,56(sp)
    5770:	f822                	sd	s0,48(sp)
    5772:	f426                	sd	s1,40(sp)
    5774:	f04a                	sd	s2,32(sp)
    5776:	ec4e                	sd	s3,24(sp)
    5778:	0080                	addi	s0,sp,64
    577a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    577c:	c299                	beqz	a3,5782 <printint+0x16>
    577e:	0805c863          	bltz	a1,580e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5782:	2581                	sext.w	a1,a1
  neg = 0;
    5784:	4881                	li	a7,0
    5786:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    578a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    578c:	2601                	sext.w	a2,a2
    578e:	00003517          	auipc	a0,0x3
    5792:	baa50513          	addi	a0,a0,-1110 # 8338 <digits>
    5796:	883a                	mv	a6,a4
    5798:	2705                	addiw	a4,a4,1
    579a:	02c5f7bb          	remuw	a5,a1,a2
    579e:	1782                	slli	a5,a5,0x20
    57a0:	9381                	srli	a5,a5,0x20
    57a2:	97aa                	add	a5,a5,a0
    57a4:	0007c783          	lbu	a5,0(a5)
    57a8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    57ac:	0005879b          	sext.w	a5,a1
    57b0:	02c5d5bb          	divuw	a1,a1,a2
    57b4:	0685                	addi	a3,a3,1
    57b6:	fec7f0e3          	bgeu	a5,a2,5796 <printint+0x2a>
  if(neg)
    57ba:	00088b63          	beqz	a7,57d0 <printint+0x64>
    buf[i++] = '-';
    57be:	fd040793          	addi	a5,s0,-48
    57c2:	973e                	add	a4,a4,a5
    57c4:	02d00793          	li	a5,45
    57c8:	fef70823          	sb	a5,-16(a4)
    57cc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    57d0:	02e05863          	blez	a4,5800 <printint+0x94>
    57d4:	fc040793          	addi	a5,s0,-64
    57d8:	00e78933          	add	s2,a5,a4
    57dc:	fff78993          	addi	s3,a5,-1
    57e0:	99ba                	add	s3,s3,a4
    57e2:	377d                	addiw	a4,a4,-1
    57e4:	1702                	slli	a4,a4,0x20
    57e6:	9301                	srli	a4,a4,0x20
    57e8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    57ec:	fff94583          	lbu	a1,-1(s2)
    57f0:	8526                	mv	a0,s1
    57f2:	00000097          	auipc	ra,0x0
    57f6:	f58080e7          	jalr	-168(ra) # 574a <putc>
  while(--i >= 0)
    57fa:	197d                	addi	s2,s2,-1
    57fc:	ff3918e3          	bne	s2,s3,57ec <printint+0x80>
}
    5800:	70e2                	ld	ra,56(sp)
    5802:	7442                	ld	s0,48(sp)
    5804:	74a2                	ld	s1,40(sp)
    5806:	7902                	ld	s2,32(sp)
    5808:	69e2                	ld	s3,24(sp)
    580a:	6121                	addi	sp,sp,64
    580c:	8082                	ret
    x = -xx;
    580e:	40b005bb          	negw	a1,a1
    neg = 1;
    5812:	4885                	li	a7,1
    x = -xx;
    5814:	bf8d                	j	5786 <printint+0x1a>

0000000000005816 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5816:	7119                	addi	sp,sp,-128
    5818:	fc86                	sd	ra,120(sp)
    581a:	f8a2                	sd	s0,112(sp)
    581c:	f4a6                	sd	s1,104(sp)
    581e:	f0ca                	sd	s2,96(sp)
    5820:	ecce                	sd	s3,88(sp)
    5822:	e8d2                	sd	s4,80(sp)
    5824:	e4d6                	sd	s5,72(sp)
    5826:	e0da                	sd	s6,64(sp)
    5828:	fc5e                	sd	s7,56(sp)
    582a:	f862                	sd	s8,48(sp)
    582c:	f466                	sd	s9,40(sp)
    582e:	f06a                	sd	s10,32(sp)
    5830:	ec6e                	sd	s11,24(sp)
    5832:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5834:	0005c903          	lbu	s2,0(a1)
    5838:	18090f63          	beqz	s2,59d6 <vprintf+0x1c0>
    583c:	8aaa                	mv	s5,a0
    583e:	8b32                	mv	s6,a2
    5840:	00158493          	addi	s1,a1,1
  state = 0;
    5844:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5846:	02500a13          	li	s4,37
      if(c == 'd'){
    584a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    584e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    5852:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5856:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    585a:	00003b97          	auipc	s7,0x3
    585e:	adeb8b93          	addi	s7,s7,-1314 # 8338 <digits>
    5862:	a839                	j	5880 <vprintf+0x6a>
        putc(fd, c);
    5864:	85ca                	mv	a1,s2
    5866:	8556                	mv	a0,s5
    5868:	00000097          	auipc	ra,0x0
    586c:	ee2080e7          	jalr	-286(ra) # 574a <putc>
    5870:	a019                	j	5876 <vprintf+0x60>
    } else if(state == '%'){
    5872:	01498f63          	beq	s3,s4,5890 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5876:	0485                	addi	s1,s1,1
    5878:	fff4c903          	lbu	s2,-1(s1)
    587c:	14090d63          	beqz	s2,59d6 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    5880:	0009079b          	sext.w	a5,s2
    if(state == 0){
    5884:	fe0997e3          	bnez	s3,5872 <vprintf+0x5c>
      if(c == '%'){
    5888:	fd479ee3          	bne	a5,s4,5864 <vprintf+0x4e>
        state = '%';
    588c:	89be                	mv	s3,a5
    588e:	b7e5                	j	5876 <vprintf+0x60>
      if(c == 'd'){
    5890:	05878063          	beq	a5,s8,58d0 <vprintf+0xba>
      } else if(c == 'l') {
    5894:	05978c63          	beq	a5,s9,58ec <vprintf+0xd6>
      } else if(c == 'x') {
    5898:	07a78863          	beq	a5,s10,5908 <vprintf+0xf2>
      } else if(c == 'p') {
    589c:	09b78463          	beq	a5,s11,5924 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    58a0:	07300713          	li	a4,115
    58a4:	0ce78663          	beq	a5,a4,5970 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    58a8:	06300713          	li	a4,99
    58ac:	0ee78e63          	beq	a5,a4,59a8 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    58b0:	11478863          	beq	a5,s4,59c0 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    58b4:	85d2                	mv	a1,s4
    58b6:	8556                	mv	a0,s5
    58b8:	00000097          	auipc	ra,0x0
    58bc:	e92080e7          	jalr	-366(ra) # 574a <putc>
        putc(fd, c);
    58c0:	85ca                	mv	a1,s2
    58c2:	8556                	mv	a0,s5
    58c4:	00000097          	auipc	ra,0x0
    58c8:	e86080e7          	jalr	-378(ra) # 574a <putc>
      }
      state = 0;
    58cc:	4981                	li	s3,0
    58ce:	b765                	j	5876 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    58d0:	008b0913          	addi	s2,s6,8
    58d4:	4685                	li	a3,1
    58d6:	4629                	li	a2,10
    58d8:	000b2583          	lw	a1,0(s6)
    58dc:	8556                	mv	a0,s5
    58de:	00000097          	auipc	ra,0x0
    58e2:	e8e080e7          	jalr	-370(ra) # 576c <printint>
    58e6:	8b4a                	mv	s6,s2
      state = 0;
    58e8:	4981                	li	s3,0
    58ea:	b771                	j	5876 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    58ec:	008b0913          	addi	s2,s6,8
    58f0:	4681                	li	a3,0
    58f2:	4629                	li	a2,10
    58f4:	000b2583          	lw	a1,0(s6)
    58f8:	8556                	mv	a0,s5
    58fa:	00000097          	auipc	ra,0x0
    58fe:	e72080e7          	jalr	-398(ra) # 576c <printint>
    5902:	8b4a                	mv	s6,s2
      state = 0;
    5904:	4981                	li	s3,0
    5906:	bf85                	j	5876 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5908:	008b0913          	addi	s2,s6,8
    590c:	4681                	li	a3,0
    590e:	4641                	li	a2,16
    5910:	000b2583          	lw	a1,0(s6)
    5914:	8556                	mv	a0,s5
    5916:	00000097          	auipc	ra,0x0
    591a:	e56080e7          	jalr	-426(ra) # 576c <printint>
    591e:	8b4a                	mv	s6,s2
      state = 0;
    5920:	4981                	li	s3,0
    5922:	bf91                	j	5876 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5924:	008b0793          	addi	a5,s6,8
    5928:	f8f43423          	sd	a5,-120(s0)
    592c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5930:	03000593          	li	a1,48
    5934:	8556                	mv	a0,s5
    5936:	00000097          	auipc	ra,0x0
    593a:	e14080e7          	jalr	-492(ra) # 574a <putc>
  putc(fd, 'x');
    593e:	85ea                	mv	a1,s10
    5940:	8556                	mv	a0,s5
    5942:	00000097          	auipc	ra,0x0
    5946:	e08080e7          	jalr	-504(ra) # 574a <putc>
    594a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    594c:	03c9d793          	srli	a5,s3,0x3c
    5950:	97de                	add	a5,a5,s7
    5952:	0007c583          	lbu	a1,0(a5)
    5956:	8556                	mv	a0,s5
    5958:	00000097          	auipc	ra,0x0
    595c:	df2080e7          	jalr	-526(ra) # 574a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5960:	0992                	slli	s3,s3,0x4
    5962:	397d                	addiw	s2,s2,-1
    5964:	fe0914e3          	bnez	s2,594c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5968:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    596c:	4981                	li	s3,0
    596e:	b721                	j	5876 <vprintf+0x60>
        s = va_arg(ap, char*);
    5970:	008b0993          	addi	s3,s6,8
    5974:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    5978:	02090163          	beqz	s2,599a <vprintf+0x184>
        while(*s != 0){
    597c:	00094583          	lbu	a1,0(s2)
    5980:	c9a1                	beqz	a1,59d0 <vprintf+0x1ba>
          putc(fd, *s);
    5982:	8556                	mv	a0,s5
    5984:	00000097          	auipc	ra,0x0
    5988:	dc6080e7          	jalr	-570(ra) # 574a <putc>
          s++;
    598c:	0905                	addi	s2,s2,1
        while(*s != 0){
    598e:	00094583          	lbu	a1,0(s2)
    5992:	f9e5                	bnez	a1,5982 <vprintf+0x16c>
        s = va_arg(ap, char*);
    5994:	8b4e                	mv	s6,s3
      state = 0;
    5996:	4981                	li	s3,0
    5998:	bdf9                	j	5876 <vprintf+0x60>
          s = "(null)";
    599a:	00003917          	auipc	s2,0x3
    599e:	99690913          	addi	s2,s2,-1642 # 8330 <malloc+0x2850>
        while(*s != 0){
    59a2:	02800593          	li	a1,40
    59a6:	bff1                	j	5982 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    59a8:	008b0913          	addi	s2,s6,8
    59ac:	000b4583          	lbu	a1,0(s6)
    59b0:	8556                	mv	a0,s5
    59b2:	00000097          	auipc	ra,0x0
    59b6:	d98080e7          	jalr	-616(ra) # 574a <putc>
    59ba:	8b4a                	mv	s6,s2
      state = 0;
    59bc:	4981                	li	s3,0
    59be:	bd65                	j	5876 <vprintf+0x60>
        putc(fd, c);
    59c0:	85d2                	mv	a1,s4
    59c2:	8556                	mv	a0,s5
    59c4:	00000097          	auipc	ra,0x0
    59c8:	d86080e7          	jalr	-634(ra) # 574a <putc>
      state = 0;
    59cc:	4981                	li	s3,0
    59ce:	b565                	j	5876 <vprintf+0x60>
        s = va_arg(ap, char*);
    59d0:	8b4e                	mv	s6,s3
      state = 0;
    59d2:	4981                	li	s3,0
    59d4:	b54d                	j	5876 <vprintf+0x60>
    }
  }
}
    59d6:	70e6                	ld	ra,120(sp)
    59d8:	7446                	ld	s0,112(sp)
    59da:	74a6                	ld	s1,104(sp)
    59dc:	7906                	ld	s2,96(sp)
    59de:	69e6                	ld	s3,88(sp)
    59e0:	6a46                	ld	s4,80(sp)
    59e2:	6aa6                	ld	s5,72(sp)
    59e4:	6b06                	ld	s6,64(sp)
    59e6:	7be2                	ld	s7,56(sp)
    59e8:	7c42                	ld	s8,48(sp)
    59ea:	7ca2                	ld	s9,40(sp)
    59ec:	7d02                	ld	s10,32(sp)
    59ee:	6de2                	ld	s11,24(sp)
    59f0:	6109                	addi	sp,sp,128
    59f2:	8082                	ret

00000000000059f4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    59f4:	715d                	addi	sp,sp,-80
    59f6:	ec06                	sd	ra,24(sp)
    59f8:	e822                	sd	s0,16(sp)
    59fa:	1000                	addi	s0,sp,32
    59fc:	e010                	sd	a2,0(s0)
    59fe:	e414                	sd	a3,8(s0)
    5a00:	e818                	sd	a4,16(s0)
    5a02:	ec1c                	sd	a5,24(s0)
    5a04:	03043023          	sd	a6,32(s0)
    5a08:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5a0c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5a10:	8622                	mv	a2,s0
    5a12:	00000097          	auipc	ra,0x0
    5a16:	e04080e7          	jalr	-508(ra) # 5816 <vprintf>
}
    5a1a:	60e2                	ld	ra,24(sp)
    5a1c:	6442                	ld	s0,16(sp)
    5a1e:	6161                	addi	sp,sp,80
    5a20:	8082                	ret

0000000000005a22 <printf>:

void
printf(const char *fmt, ...)
{
    5a22:	711d                	addi	sp,sp,-96
    5a24:	ec06                	sd	ra,24(sp)
    5a26:	e822                	sd	s0,16(sp)
    5a28:	1000                	addi	s0,sp,32
    5a2a:	e40c                	sd	a1,8(s0)
    5a2c:	e810                	sd	a2,16(s0)
    5a2e:	ec14                	sd	a3,24(s0)
    5a30:	f018                	sd	a4,32(s0)
    5a32:	f41c                	sd	a5,40(s0)
    5a34:	03043823          	sd	a6,48(s0)
    5a38:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5a3c:	00840613          	addi	a2,s0,8
    5a40:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5a44:	85aa                	mv	a1,a0
    5a46:	4505                	li	a0,1
    5a48:	00000097          	auipc	ra,0x0
    5a4c:	dce080e7          	jalr	-562(ra) # 5816 <vprintf>
}
    5a50:	60e2                	ld	ra,24(sp)
    5a52:	6442                	ld	s0,16(sp)
    5a54:	6125                	addi	sp,sp,96
    5a56:	8082                	ret

0000000000005a58 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5a58:	1141                	addi	sp,sp,-16
    5a5a:	e422                	sd	s0,8(sp)
    5a5c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5a5e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5a62:	00003797          	auipc	a5,0x3
    5a66:	8fe7b783          	ld	a5,-1794(a5) # 8360 <freep>
    5a6a:	a805                	j	5a9a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5a6c:	4618                	lw	a4,8(a2)
    5a6e:	9db9                	addw	a1,a1,a4
    5a70:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5a74:	6398                	ld	a4,0(a5)
    5a76:	6318                	ld	a4,0(a4)
    5a78:	fee53823          	sd	a4,-16(a0)
    5a7c:	a091                	j	5ac0 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5a7e:	ff852703          	lw	a4,-8(a0)
    5a82:	9e39                	addw	a2,a2,a4
    5a84:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5a86:	ff053703          	ld	a4,-16(a0)
    5a8a:	e398                	sd	a4,0(a5)
    5a8c:	a099                	j	5ad2 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5a8e:	6398                	ld	a4,0(a5)
    5a90:	00e7e463          	bltu	a5,a4,5a98 <free+0x40>
    5a94:	00e6ea63          	bltu	a3,a4,5aa8 <free+0x50>
{
    5a98:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5a9a:	fed7fae3          	bgeu	a5,a3,5a8e <free+0x36>
    5a9e:	6398                	ld	a4,0(a5)
    5aa0:	00e6e463          	bltu	a3,a4,5aa8 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5aa4:	fee7eae3          	bltu	a5,a4,5a98 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    5aa8:	ff852583          	lw	a1,-8(a0)
    5aac:	6390                	ld	a2,0(a5)
    5aae:	02059713          	slli	a4,a1,0x20
    5ab2:	9301                	srli	a4,a4,0x20
    5ab4:	0712                	slli	a4,a4,0x4
    5ab6:	9736                	add	a4,a4,a3
    5ab8:	fae60ae3          	beq	a2,a4,5a6c <free+0x14>
    bp->s.ptr = p->s.ptr;
    5abc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5ac0:	4790                	lw	a2,8(a5)
    5ac2:	02061713          	slli	a4,a2,0x20
    5ac6:	9301                	srli	a4,a4,0x20
    5ac8:	0712                	slli	a4,a4,0x4
    5aca:	973e                	add	a4,a4,a5
    5acc:	fae689e3          	beq	a3,a4,5a7e <free+0x26>
  } else
    p->s.ptr = bp;
    5ad0:	e394                	sd	a3,0(a5)
  freep = p;
    5ad2:	00003717          	auipc	a4,0x3
    5ad6:	88f73723          	sd	a5,-1906(a4) # 8360 <freep>
}
    5ada:	6422                	ld	s0,8(sp)
    5adc:	0141                	addi	sp,sp,16
    5ade:	8082                	ret

0000000000005ae0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5ae0:	7139                	addi	sp,sp,-64
    5ae2:	fc06                	sd	ra,56(sp)
    5ae4:	f822                	sd	s0,48(sp)
    5ae6:	f426                	sd	s1,40(sp)
    5ae8:	f04a                	sd	s2,32(sp)
    5aea:	ec4e                	sd	s3,24(sp)
    5aec:	e852                	sd	s4,16(sp)
    5aee:	e456                	sd	s5,8(sp)
    5af0:	e05a                	sd	s6,0(sp)
    5af2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5af4:	02051493          	slli	s1,a0,0x20
    5af8:	9081                	srli	s1,s1,0x20
    5afa:	04bd                	addi	s1,s1,15
    5afc:	8091                	srli	s1,s1,0x4
    5afe:	0014899b          	addiw	s3,s1,1
    5b02:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5b04:	00003517          	auipc	a0,0x3
    5b08:	85c53503          	ld	a0,-1956(a0) # 8360 <freep>
    5b0c:	c515                	beqz	a0,5b38 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5b0e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5b10:	4798                	lw	a4,8(a5)
    5b12:	02977f63          	bgeu	a4,s1,5b50 <malloc+0x70>
    5b16:	8a4e                	mv	s4,s3
    5b18:	0009871b          	sext.w	a4,s3
    5b1c:	6685                	lui	a3,0x1
    5b1e:	00d77363          	bgeu	a4,a3,5b24 <malloc+0x44>
    5b22:	6a05                	lui	s4,0x1
    5b24:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5b28:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5b2c:	00003917          	auipc	s2,0x3
    5b30:	83490913          	addi	s2,s2,-1996 # 8360 <freep>
  if(p == (char*)-1)
    5b34:	5afd                	li	s5,-1
    5b36:	a88d                	j	5ba8 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    5b38:	00009797          	auipc	a5,0x9
    5b3c:	04878793          	addi	a5,a5,72 # eb80 <base>
    5b40:	00003717          	auipc	a4,0x3
    5b44:	82f73023          	sd	a5,-2016(a4) # 8360 <freep>
    5b48:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5b4a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5b4e:	b7e1                	j	5b16 <malloc+0x36>
      if(p->s.size == nunits)
    5b50:	02e48b63          	beq	s1,a4,5b86 <malloc+0xa6>
        p->s.size -= nunits;
    5b54:	4137073b          	subw	a4,a4,s3
    5b58:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5b5a:	1702                	slli	a4,a4,0x20
    5b5c:	9301                	srli	a4,a4,0x20
    5b5e:	0712                	slli	a4,a4,0x4
    5b60:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5b62:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5b66:	00002717          	auipc	a4,0x2
    5b6a:	7ea73d23          	sd	a0,2042(a4) # 8360 <freep>
      return (void*)(p + 1);
    5b6e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5b72:	70e2                	ld	ra,56(sp)
    5b74:	7442                	ld	s0,48(sp)
    5b76:	74a2                	ld	s1,40(sp)
    5b78:	7902                	ld	s2,32(sp)
    5b7a:	69e2                	ld	s3,24(sp)
    5b7c:	6a42                	ld	s4,16(sp)
    5b7e:	6aa2                	ld	s5,8(sp)
    5b80:	6b02                	ld	s6,0(sp)
    5b82:	6121                	addi	sp,sp,64
    5b84:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5b86:	6398                	ld	a4,0(a5)
    5b88:	e118                	sd	a4,0(a0)
    5b8a:	bff1                	j	5b66 <malloc+0x86>
  hp->s.size = nu;
    5b8c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5b90:	0541                	addi	a0,a0,16
    5b92:	00000097          	auipc	ra,0x0
    5b96:	ec6080e7          	jalr	-314(ra) # 5a58 <free>
  return freep;
    5b9a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5b9e:	d971                	beqz	a0,5b72 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5ba0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5ba2:	4798                	lw	a4,8(a5)
    5ba4:	fa9776e3          	bgeu	a4,s1,5b50 <malloc+0x70>
    if(p == freep)
    5ba8:	00093703          	ld	a4,0(s2)
    5bac:	853e                	mv	a0,a5
    5bae:	fef719e3          	bne	a4,a5,5ba0 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    5bb2:	8552                	mv	a0,s4
    5bb4:	00000097          	auipc	ra,0x0
    5bb8:	b7e080e7          	jalr	-1154(ra) # 5732 <sbrk>
  if(p == (char*)-1)
    5bbc:	fd5518e3          	bne	a0,s5,5b8c <malloc+0xac>
        return 0;
    5bc0:	4501                	li	a0,0
    5bc2:	bf45                	j	5b72 <malloc+0x92>
