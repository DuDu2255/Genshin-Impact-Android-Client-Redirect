
lib/arm64-v8a/libreadtoendhook.so:	file format elf64-littleaarch64

Disassembly of section .text:

0000000000001450 <__on_dlclose>:
    1450: d503245f     	bti	c
    1454: b0000020     	adrp	x0, 0x6000 <strncmp@plt+0x3290>
    1458: 91360000     	add	x0, x0, #0xd80
    145c: 140005f5     	b	0x2c30 <__cxa_finalize@plt>

0000000000001460 <__emutls_unregister_key>:
    1460: d503245f     	bti	c
    1464: d65f03c0     	ret

0000000000001468 <__on_dlclose_late>:
    1468: d503245f     	bti	c
    146c: 17fffffd     	b	0x1460 <__emutls_unregister_key>

0000000000001470 <__atexit_handler_wrapper>:
    1470: d503245f     	bti	c
    1474: b4000060     	cbz	x0, 0x1480 <__atexit_handler_wrapper+0x10>
    1478: aa0003f0     	mov	x16, x0
    147c: d61f0200     	br	x16
    1480: d65f03c0     	ret

0000000000001484 <atexit>:
    1484: d503245f     	bti	c
    1488: aa0003e1     	mov	x1, x0
    148c: 90000000     	adrp	x0, 0x1000 <kCnOriginal+0x4de>
    1490: b0000022     	adrp	x2, 0x6000 <strncmp@plt+0x3290>
    1494: 9111c000     	add	x0, x0, #0x470
    1498: 91360042     	add	x2, x2, #0xd80
    149c: 140005e9     	b	0x2c40 <__cxa_atexit@plt>

00000000000014a0 <A64HookFunctionV>:
    14a0: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
    14a4: a90157f6     	stp	x22, x21, [sp, #0x10]
    14a8: 910003fd     	mov	x29, sp
    14ac: a9024ff4     	stp	x20, x19, [sp, #0x20]
    14b0: cb000036     	sub	x22, x1, x0
    14b4: aa0203f4     	mov	x20, x2
    14b8: 9342fec8     	asr	x8, x22, #2
    14bc: aa0003f3     	mov	x19, x0
    14c0: f100011f     	cmp	x8, #0x0
    14c4: 12bfc009     	mov	w9, #0x1ffffff          // =33554431
    14c8: da885508     	cneg	x8, x8, mi
    14cc: eb09011f     	cmp	x8, x9
    14d0: 54000243     	b.lo	0x1518 <A64HookFunctionV+0x78>
    14d4: 11002268     	add	w8, w19, #0x8
    14d8: aa0103f5     	mov	x21, x1
    14dc: f2400916     	ands	x22, x8, #0x7
    14e0: 52800088     	mov	w8, #0x4                // =4
    14e4: 1a880501     	cinc	w1, w8, ne
    14e8: b40003f4     	cbz	x20, 0x1564 <A64HookFunctionV+0xc4>
    14ec: 0b010828     	add	w8, w1, w1, lsl #2
    14f0: 531f7908     	lsl	w8, w8, #1
    14f4: eb03011f     	cmp	x8, x3
    14f8: 54000309     	b.ls	0x1558 <A64HookFunctionV+0xb8>
    14fc: f0ffffe1     	adrp	x1, 0x0 <vsnprintf>
    1500: f0ffffe2     	adrp	x2, 0x0 <vsnprintf>
    1504: 91330821     	add	x1, x1, #0xcc2
    1508: 91340c42     	add	x2, x2, #0xd03
    150c: 528000c0     	mov	w0, #0x6                // =6
    1510: 2a0803e3     	mov	w3, w8
    1514: 1400000a     	b	0x153c <A64HookFunctionV+0x9c>
    1518: b40005b4     	cbz	x20, 0x15cc <A64HookFunctionV+0x12c>
    151c: f100247f     	cmp	x3, #0x9
    1520: 540004e8     	b.hi	0x15bc <A64HookFunctionV+0x11c>
    1524: f0ffffe1     	adrp	x1, 0x0 <vsnprintf>
    1528: f0ffffe2     	adrp	x2, 0x0 <vsnprintf>
    152c: 91330821     	add	x1, x1, #0xcc2
    1530: 91340c42     	add	x2, x2, #0xd03
    1534: 528000c0     	mov	w0, #0x6                // =6
    1538: 52800143     	mov	w3, #0xa                // =10
    153c: 940005c9     	bl	0x2c60 <__android_log_print@plt>
    1540: aa1f03f4     	mov	x20, xzr
    1544: aa1403e0     	mov	x0, x20
    1548: a9424ff4     	ldp	x20, x19, [sp, #0x20]
    154c: a94157f6     	ldp	x22, x21, [sp, #0x10]
    1550: a8c37bfd     	ldp	x29, x30, [sp], #0x30
    1554: d65f03c0     	ret
    1558: aa1303e0     	mov	x0, x19
    155c: aa1403e2     	mov	x2, x20
    1560: 94000058     	bl	0x16c0 <_ZL18__fix_instructionsPjiS_>
    1564: 52820268     	mov	w8, #0x1013             // =4115
    1568: 913ffe69     	add	x9, x19, #0xfff
    156c: 8b080268     	add	x8, x19, x8
    1570: 9274ce60     	and	x0, x19, #0xfffffffffffff000
    1574: ca090108     	eor	x8, x8, x9
    1578: 52820009     	mov	w9, #0x1000             // =4096
    157c: f140051f     	cmp	x8, #0x1, lsl #12       // =0x1000
    1580: 52840008     	mov	w8, #0x2000             // =8192
    1584: 9a883121     	csel	x1, x9, x8, lo
    1588: 528000e2     	mov	w2, #0x7                // =7
    158c: 940005b9     	bl	0x2c70 <mprotect@plt>
    1590: 34000560     	cbz	w0, 0x163c <A64HookFunctionV+0x19c>
    1594: 940005bb     	bl	0x2c80 <__errno@plt>
    1598: b9400003     	ldr	w3, [x0]
    159c: f0ffffe1     	adrp	x1, 0x0 <vsnprintf>
    15a0: f0ffffe2     	adrp	x2, 0x0 <vsnprintf>
    15a4: 91330821     	add	x1, x1, #0xcc2
    15a8: 912a1842     	add	x2, x2, #0xa86
    15ac: 528000c0     	mov	w0, #0x6                // =6
    15b0: aa1303e4     	mov	x4, x19
    15b4: 52800285     	mov	w5, #0x14               // =20
    15b8: 1400001a     	b	0x1620 <A64HookFunctionV+0x180>
    15bc: aa1303e0     	mov	x0, x19
    15c0: 52800021     	mov	w1, #0x1                // =1
    15c4: aa1403e2     	mov	x2, x20
    15c8: 9400003e     	bl	0x16c0 <_ZL18__fix_instructionsPjiS_>
    15cc: 52820068     	mov	w8, #0x1003             // =4099
    15d0: 913ffe69     	add	x9, x19, #0xfff
    15d4: 8b080268     	add	x8, x19, x8
    15d8: 9274ce60     	and	x0, x19, #0xfffffffffffff000
    15dc: ca090108     	eor	x8, x8, x9
    15e0: 52820009     	mov	w9, #0x1000             // =4096
    15e4: f140051f     	cmp	x8, #0x1, lsl #12       // =0x1000
    15e8: 52840008     	mov	w8, #0x2000             // =8192
    15ec: 9a883121     	csel	x1, x9, x8, lo
    15f0: 528000e2     	mov	w2, #0x7                // =7
    15f4: 9400059f     	bl	0x2c70 <mprotect@plt>
    15f8: 340002e0     	cbz	w0, 0x1654 <A64HookFunctionV+0x1b4>
    15fc: 940005a1     	bl	0x2c80 <__errno@plt>
    1600: f0ffffe1     	adrp	x1, 0x0 <vsnprintf>
    1604: f0ffffe2     	adrp	x2, 0x0 <vsnprintf>
    1608: b9400003     	ldr	w3, [x0]
    160c: 91330821     	add	x1, x1, #0xcc2
    1610: 912a1842     	add	x2, x2, #0xa86
    1614: 528000c0     	mov	w0, #0x6                // =6
    1618: aa1303e4     	mov	x4, x19
    161c: 52800085     	mov	w5, #0x4                // =4
    1620: 94000590     	bl	0x2c60 <__android_log_print@plt>
    1624: aa1f03f4     	mov	x20, xzr
    1628: aa1403e0     	mov	x0, x20
    162c: a9424ff4     	ldp	x20, x19, [sp, #0x20]
    1630: a94157f6     	ldp	x22, x21, [sp, #0x10]
    1634: a8c37bfd     	ldp	x29, x30, [sp], #0x30
    1638: d65f03c0     	ret
    163c: b4000296     	cbz	x22, 0x168c <A64HookFunctionV+0x1ec>
    1640: 528403e9     	mov	w9, #0x201f             // =8223
    1644: aa1303e8     	mov	x8, x19
    1648: 72baa069     	movk	w9, #0xd503, lsl #16
    164c: b8004509     	str	w9, [x8], #0x4
    1650: 14000010     	b	0x1690 <A64HookFunctionV+0x1f0>
    1654: aa1303f5     	mov	x21, x19
    1658: 52a28001     	mov	w1, #0x14000000         // =335544320
    165c: 33026ec1     	bfxil	w1, w22, #2, #26
    1660: aa1303e2     	mov	x2, x19
    1664: b84046a0     	ldr	w0, [x21], #0x4
    1668: 9400051e     	bl	0x2ae0 <__aarch64_cas4_acq_rel>
    166c: aa1303e0     	mov	x0, x19
    1670: aa1503e1     	mov	x1, x21
    1674: 940004f6     	bl	0x2a4c <__clear_cache>
    1678: aa1403e0     	mov	x0, x20
    167c: a9424ff4     	ldp	x20, x19, [sp, #0x20]
    1680: a94157f6     	ldp	x22, x21, [sp, #0x10]
    1684: a8c37bfd     	ldp	x29, x30, [sp], #0x30
    1688: d65f03c0     	ret
    168c: aa1303e8     	mov	x8, x19
    1690: f0ffffe9     	adrp	x9, 0x0 <vsnprintf>
    1694: 91005261     	add	x1, x19, #0x14
    1698: aa1303e0     	mov	x0, x19
    169c: f9000515     	str	x21, [x8, #0x8]
    16a0: fd452d20     	ldr	d0, [x9, #0xa58]
    16a4: fd000100     	str	d0, [x8]
    16a8: 940004e9     	bl	0x2a4c <__clear_cache>
    16ac: aa1403e0     	mov	x0, x20
    16b0: a9424ff4     	ldp	x20, x19, [sp, #0x20]
    16b4: a94157f6     	ldp	x22, x21, [sp, #0x10]
    16b8: a8c37bfd     	ldp	x29, x30, [sp], #0x30
    16bc: d65f03c0     	ret

00000000000016c0 <_ZL18__fix_instructionsPjiS_>:
    16c0: fc170fec     	str	d12, [sp, #-0x90]!
    16c4: 6d012beb     	stp	d11, d10, [sp, #0x10]
    16c8: 6d0223e9     	stp	d9, d8, [sp, #0x20]
    16cc: a9037bfd     	stp	x29, x30, [sp, #0x30]
    16d0: 9100c3fd     	add	x29, sp, #0x30
    16d4: a9046ffc     	stp	x28, x27, [sp, #0x40]
    16d8: a90567fa     	stp	x26, x25, [sp, #0x50]
    16dc: a9065ff8     	stp	x24, x23, [sp, #0x60]
    16e0: a90757f6     	stp	x22, x21, [sp, #0x70]
    16e4: a9084ff4     	stp	x20, x19, [sp, #0x80]
    16e8: d10e03ff     	sub	sp, sp, #0x380
    16ec: d53bd059     	mrs	x25, TPIDR_EL0
    16f0: 910063fc     	add	x28, sp, #0x18
    16f4: aa0203f7     	mov	x23, x2
    16f8: 2a0103f5     	mov	w21, w1
    16fc: aa0003f4     	mov	x20, x0
    1700: f9401728     	ldr	x8, [x25, #0x28]
    1704: 8b214809     	add	x9, x0, w1, uxtw #2
    1708: 91004380     	add	x0, x28, #0x10
    170c: 2a1f03e1     	mov	w1, wzr
    1710: 52806902     	mov	w2, #0x348              // =840
    1714: f81c03a8     	stur	x8, [x29, #-0x40]
    1718: a901a7f4     	stp	x20, x9, [sp, #0x18]
    171c: 9400055d     	bl	0x2c90 <memset@plt>
    1720: f0ffffea     	adrp	x10, 0x0 <vsnprintf>
    1724: 710006bf     	cmp	w21, #0x1
    1728: 54003d8b     	b.lt	0x1ed8 <_ZL18__fix_instructionsPjiS_+0x818>
    172c: f0ffffe8     	adrp	x8, 0x0 <vsnprintf>
    1730: f0ffffe9     	adrp	x9, 0x0 <vsnprintf>
    1734: d100129b     	sub	x27, x20, #0x4
    1738: 5280151a     	mov	w26, #0xa8              // =168
    173c: fd452d48     	ldr	d8, [x10, #0xa58]
    1740: 528000eb     	mov	w11, #0x7               // =7
    1744: fd453109     	ldr	d9, [x8, #0xa60]
    1748: f0ffffe8     	adrp	x8, 0x0 <vsnprintf>
    174c: fd45392a     	ldr	d10, [x9, #0xa70]
    1750: 5280006c     	mov	w12, #0x3               // =3
    1754: aa1703f6     	mov	x22, x23
    1758: fd45350b     	ldr	d11, [x8, #0xa68]
    175c: f0ffffe8     	adrp	x8, 0x0 <vsnprintf>
    1760: fd45290c     	ldr	d12, [x8, #0xa50]
    1764: b9400298     	ldr	w24, [x20]
    1768: 510006b3     	sub	w19, w21, #0x1
    176c: 52b2800a     	mov	w10, #-0x6c000000       // =-1811939328
    1770: 12061708     	and	w8, w24, #0xfc000000
    1774: 32010109     	orr	w9, w8, #0x80000000
    1778: 6b0a013f     	cmp	w9, w10
    177c: 540004c1     	b.ne	0x1814 <_ZL18__fix_instructionsPjiS_+0x154>
    1780: a941b3e9     	ldp	x9, x12, [sp, #0x18]
    1784: 131e670a     	sbfiz	w10, w24, #2, #26
    1788: 8b2ac28e     	add	x14, x20, w10, sxtw
    178c: cb09028a     	sub	x10, x20, x9
    1790: eb0901cb     	subs	x11, x14, x9
    1794: d342fd41     	lsr	x1, x10, #2
    1798: cb1601ca     	sub	x10, x14, x22
    179c: 1a9fb7ed     	cset	w13, ge
    17a0: eb0e019f     	cmp	x12, x14
    17a4: 9342fd4a     	asr	x10, x10, #2
    17a8: 9b1a7029     	madd	x9, x1, x26, x28
    17ac: 1a9fd7ec     	cset	w12, gt
    17b0: f100015f     	cmp	x10, #0x0
    17b4: 0a0c01ac     	and	w12, w13, w12
    17b8: da8a554d     	cneg	x13, x10, mi
    17bc: 7100059f     	cmp	w12, #0x1
    17c0: f9000bee     	str	x14, [sp, #0x10]
    17c4: f8010d36     	str	x22, [x9, #0x10]!
    17c8: 54000440     	b.eq	0x1850 <_ZL18__fix_instructionsPjiS_+0x190>
    17cc: 12bfc00e     	mov	w14, #0x1ffffff         // =33554431
    17d0: eb0e01bf     	cmp	x13, x14
    17d4: 540003e3     	b.lo	0x1850 <_ZL18__fix_instructionsPjiS_+0x190>
    17d8: 110022ca     	add	w10, w22, #0x8
    17dc: 52a2800b     	mov	w11, #0x14000000        // =335544320
    17e0: 9240094a     	and	x10, x10, #0x7
    17e4: 6b0b011f     	cmp	w8, w11
    17e8: 54000e81     	b.ne	0x19b8 <_ZL18__fix_instructionsPjiS_+0x2f8>
    17ec: b40000aa     	cbz	x10, 0x1800 <_ZL18__fix_instructionsPjiS_+0x140>
    17f0: 528403e8     	mov	w8, #0x201f             // =8223
    17f4: 72baa068     	movk	w8, #0xd503, lsl #16
    17f8: b80046c8     	str	w8, [x22], #0x4
    17fc: f9000136     	str	x22, [x9]
    1800: f9400be8     	ldr	x8, [sp, #0x10]
    1804: fd0002c8     	str	d8, [x22]
    1808: f90006c8     	str	x8, [x22, #0x8]
    180c: 910042d6     	add	x22, x22, #0x10
    1810: 140000a7     	b	0x1aac <_ZL18__fix_instructionsPjiS_+0x3ec>
    1814: 52800208     	mov	w8, #0x10               // =16
    1818: 52aa8009     	mov	w9, #0x54000000         // =1409286144
    181c: 72bfe008     	movk	w8, #0xff00, lsl #16
    1820: 0a080308     	and	w8, w24, w8
    1824: 6b09011f     	cmp	w8, w9
    1828: 540005c0     	b.eq	0x18e0 <_ZL18__fix_instructionsPjiS_+0x220>
    182c: 12071708     	and	w8, w24, #0x7e000000
    1830: 52a68009     	mov	w9, #0x34000000         // =872415232
    1834: 6b09011f     	cmp	w8, w9
    1838: 54000540     	b.eq	0x18e0 <_ZL18__fix_instructionsPjiS_+0x220>
    183c: 52a6c009     	mov	w9, #0x36000000         // =905969664
    1840: 6b09011f     	cmp	w8, w9
    1844: 54001481     	b.ne	0x1ad4 <_ZL18__fix_instructionsPjiS_+0x414>
    1848: 320d47e8     	mov	w8, #-0x7ffe1           // =-524257
    184c: 14000026     	b	0x18e4 <_ZL18__fix_instructionsPjiS_+0x224>
    1850: 3400110c     	cbz	w12, 0x1a70 <_ZL18__fix_instructionsPjiS_+0x3b0>
    1854: d342fd6a     	lsr	x10, x11, #2
    1858: eb01015f     	cmp	x10, x1
    185c: 54000fa9     	b.ls	0x1a50 <_ZL18__fix_instructionsPjiS_+0x390>
    1860: 9b1a7149     	madd	x9, x10, x26, x28
    1864: f8418d2b     	ldr	x11, [x9, #0x18]!
    1868: b4000feb     	cbz	x11, 0x1a64 <_ZL18__fix_instructionsPjiS_+0x3a4>
    186c: 9b1a7149     	madd	x9, x10, x26, x28
    1870: f8428d2b     	ldr	x11, [x9, #0x28]!
    1874: b4000f8b     	cbz	x11, 0x1a64 <_ZL18__fix_instructionsPjiS_+0x3a4>
    1878: 9b1a7149     	madd	x9, x10, x26, x28
    187c: f8438d2b     	ldr	x11, [x9, #0x38]!
    1880: b4000f2b     	cbz	x11, 0x1a64 <_ZL18__fix_instructionsPjiS_+0x3a4>
    1884: 9b1a7149     	madd	x9, x10, x26, x28
    1888: f8448d2b     	ldr	x11, [x9, #0x48]!
    188c: b4000ecb     	cbz	x11, 0x1a64 <_ZL18__fix_instructionsPjiS_+0x3a4>
    1890: 9b1a7149     	madd	x9, x10, x26, x28
    1894: f8458d2b     	ldr	x11, [x9, #0x58]!
    1898: b4000e6b     	cbz	x11, 0x1a64 <_ZL18__fix_instructionsPjiS_+0x3a4>
    189c: 9b1a7149     	madd	x9, x10, x26, x28
    18a0: f8468d2b     	ldr	x11, [x9, #0x68]!
    18a4: b4000e0b     	cbz	x11, 0x1a64 <_ZL18__fix_instructionsPjiS_+0x3a4>
    18a8: 9b1a7149     	madd	x9, x10, x26, x28
    18ac: f8478d2b     	ldr	x11, [x9, #0x78]!
    18b0: b4000dab     	cbz	x11, 0x1a64 <_ZL18__fix_instructionsPjiS_+0x3a4>
    18b4: 9b1a7149     	madd	x9, x10, x26, x28
    18b8: f8488d2b     	ldr	x11, [x9, #0x88]!
    18bc: b4000d4b     	cbz	x11, 0x1a64 <_ZL18__fix_instructionsPjiS_+0x3a4>
    18c0: 9b1a7149     	madd	x9, x10, x26, x28
    18c4: f8498d2b     	ldr	x11, [x9, #0x98]!
    18c8: b4000ceb     	cbz	x11, 0x1a64 <_ZL18__fix_instructionsPjiS_+0x3a4>
    18cc: 9b1a7149     	madd	x9, x10, x26, x28
    18d0: f84a8d2a     	ldr	x10, [x9, #0xa8]!
    18d4: b4000c8a     	cbz	x10, 0x1a64 <_ZL18__fix_instructionsPjiS_+0x3a4>
    18d8: aa1f03ea     	mov	x10, xzr
    18dc: 14000065     	b	0x1a70 <_ZL18__fix_instructionsPjiS_+0x3b0>
    18e0: 320833e8     	mov	w8, #-0xffffe1          // =-16777185
    18e4: 2a2803e9     	mvn	w9, w8
    18e8: f9400fec     	ldr	x12, [sp, #0x18]
    18ec: 5ac0112a     	clz	w10, w9
    18f0: 0a28030e     	bic	w14, w24, w8
    18f4: 11000d4b     	add	w11, w10, #0x3
    18f8: cb0c028d     	sub	x13, x20, x12
    18fc: 1aca21ca     	lsl	w10, w14, w10
    1900: d342fda1     	lsr	x1, x13, #2
    1904: 1acb294b     	asr	w11, w10, w11
    1908: 9b1a702a     	madd	x10, x1, x26, x28
    190c: 8b2bc28b     	add	x11, x20, w11, sxtw
    1910: eb0c016c     	subs	x12, x11, x12
    1914: f8010d56     	str	x22, [x10, #0x10]!
    1918: f9000beb     	str	x11, [sp, #0x10]
    191c: 5400068b     	b.lt	0x19ec <_ZL18__fix_instructionsPjiS_+0x32c>
    1920: f94013ed     	ldr	x13, [sp, #0x20]
    1924: eb0b01bf     	cmp	x13, x11
    1928: 5400062d     	b.le	0x19ec <_ZL18__fix_instructionsPjiS_+0x32c>
    192c: d342fd8b     	lsr	x11, x12, #2
    1930: eb01017f     	cmp	x11, x1
    1934: 54000a29     	b.ls	0x1a78 <_ZL18__fix_instructionsPjiS_+0x3b8>
    1938: 9b1a716a     	madd	x10, x11, x26, x28
    193c: f8418d4c     	ldr	x12, [x10, #0x18]!
    1940: b4000a6c     	cbz	x12, 0x1a8c <_ZL18__fix_instructionsPjiS_+0x3cc>
    1944: 9b1a716a     	madd	x10, x11, x26, x28
    1948: f8428d4c     	ldr	x12, [x10, #0x28]!
    194c: b4000a0c     	cbz	x12, 0x1a8c <_ZL18__fix_instructionsPjiS_+0x3cc>
    1950: 9b1a716a     	madd	x10, x11, x26, x28
    1954: f8438d4c     	ldr	x12, [x10, #0x38]!
    1958: b40009ac     	cbz	x12, 0x1a8c <_ZL18__fix_instructionsPjiS_+0x3cc>
    195c: 9b1a716a     	madd	x10, x11, x26, x28
    1960: f8448d4c     	ldr	x12, [x10, #0x48]!
    1964: b400094c     	cbz	x12, 0x1a8c <_ZL18__fix_instructionsPjiS_+0x3cc>
    1968: 9b1a716a     	madd	x10, x11, x26, x28
    196c: f8458d4c     	ldr	x12, [x10, #0x58]!
    1970: b40008ec     	cbz	x12, 0x1a8c <_ZL18__fix_instructionsPjiS_+0x3cc>
    1974: 9b1a716a     	madd	x10, x11, x26, x28
    1978: f8468d4c     	ldr	x12, [x10, #0x68]!
    197c: b400088c     	cbz	x12, 0x1a8c <_ZL18__fix_instructionsPjiS_+0x3cc>
    1980: 9b1a716a     	madd	x10, x11, x26, x28
    1984: f8478d4c     	ldr	x12, [x10, #0x78]!
    1988: b400082c     	cbz	x12, 0x1a8c <_ZL18__fix_instructionsPjiS_+0x3cc>
    198c: 9b1a716a     	madd	x10, x11, x26, x28
    1990: f8488d4c     	ldr	x12, [x10, #0x88]!
    1994: b40007cc     	cbz	x12, 0x1a8c <_ZL18__fix_instructionsPjiS_+0x3cc>
    1998: 9b1a716a     	madd	x10, x11, x26, x28
    199c: f8498d4c     	ldr	x12, [x10, #0x98]!
    19a0: b400076c     	cbz	x12, 0x1a8c <_ZL18__fix_instructionsPjiS_+0x3cc>
    19a4: 9b1a716a     	madd	x10, x11, x26, x28
    19a8: f84a8d4b     	ldr	x11, [x10, #0xa8]!
    19ac: b400070b     	cbz	x11, 0x1a8c <_ZL18__fix_instructionsPjiS_+0x3cc>
    19b0: aa1f03eb     	mov	x11, xzr
    19b4: 1400003a     	b	0x1a9c <_ZL18__fix_instructionsPjiS_+0x3dc>
    19b8: b50000aa     	cbnz	x10, 0x19cc <_ZL18__fix_instructionsPjiS_+0x30c>
    19bc: 528403e8     	mov	w8, #0x201f             // =8223
    19c0: 72baa068     	movk	w8, #0xd503, lsl #16
    19c4: b80046c8     	str	w8, [x22], #0x4
    19c8: f9000136     	str	x22, [x9]
    19cc: 52804409     	mov	w9, #0x220              // =544
    19d0: f9400be8     	ldr	x8, [sp, #0x10]
    19d4: 72bac3e9     	movk	w9, #0xd61f, lsl #16
    19d8: fd0002c9     	str	d9, [x22]
    19dc: f800c2c8     	stur	x8, [x22, #0xc]
    19e0: b9000ac9     	str	w9, [x22, #0x8]
    19e4: 910052d6     	add	x22, x22, #0x14
    19e8: 14000031     	b	0x1aac <_ZL18__fix_instructionsPjiS_+0x3ec>
    19ec: cb16016b     	sub	x11, x11, x22
    19f0: 53067d2d     	lsr	w13, w9, #6
    19f4: 9342fd6b     	asr	x11, x11, #2
    19f8: f100017f     	cmp	x11, #0x0
    19fc: da8b556c     	cneg	x12, x11, mi
    1a00: eb0d019f     	cmp	x12, x13
    1a04: 540004c3     	b.lo	0x1a9c <_ZL18__fix_instructionsPjiS_+0x3dc>
    1a08: 110042c9     	add	w9, w22, #0x10
    1a0c: f240093f     	tst	x9, #0x7
    1a10: 540000a0     	b.eq	0x1a24 <_ZL18__fix_instructionsPjiS_+0x364>
    1a14: 528403e9     	mov	w9, #0x201f             // =8223
    1a18: 72baa069     	movk	w9, #0xd503, lsl #16
    1a1c: b80046c9     	str	w9, [x22], #0x4
    1a20: f9000156     	str	x22, [x10]
    1a24: 0a180108     	and	w8, w8, w24
    1a28: 5280440a     	mov	w10, #0x220             // =544
    1a2c: 321a0108     	orr	w8, w8, #0x40
    1a30: f9400be9     	ldr	x9, [sp, #0x10]
    1a34: 72bac3ea     	movk	w10, #0xd61f, lsl #16
    1a38: fc0042cb     	stur	d11, [x22, #0x4]
    1a3c: b90002c8     	str	w8, [x22]
    1a40: b9000eca     	str	w10, [x22, #0xc]
    1a44: f9000ac9     	str	x9, [x22, #0x10]
    1a48: 910062d6     	add	x22, x22, #0x18
    1a4c: 14000018     	b	0x1aac <_ZL18__fix_instructionsPjiS_+0x3ec>
    1a50: 9b1a7149     	madd	x9, x10, x26, x28
    1a54: f9400929     	ldr	x9, [x9, #0x10]
    1a58: cb160129     	sub	x9, x9, x22
    1a5c: 9342fd2a     	asr	x10, x9, #2
    1a60: 14000004     	b	0x1a70 <_ZL18__fix_instructionsPjiS_+0x3b0>
    1a64: aa1f03ea     	mov	x10, xzr
    1a68: f9000136     	str	x22, [x9]
    1a6c: fd00052a     	str	d10, [x9, #0x8]
    1a70: 12006549     	and	w9, w10, #0x3ffffff
    1a74: 1400000c     	b	0x1aa4 <_ZL18__fix_instructionsPjiS_+0x3e4>
    1a78: 9b1a716a     	madd	x10, x11, x26, x28
    1a7c: f940094a     	ldr	x10, [x10, #0x10]
    1a80: cb16014a     	sub	x10, x10, x22
    1a84: 9342fd4b     	asr	x11, x10, #2
    1a88: 14000005     	b	0x1a9c <_ZL18__fix_instructionsPjiS_+0x3dc>
    1a8c: 528000ac     	mov	w12, #0x5               // =5
    1a90: aa1f03eb     	mov	x11, xzr
    1a94: f9000156     	str	x22, [x10]
    1a98: 2901254c     	stp	w12, w9, [x10, #0x8]
    1a9c: 0a0b1529     	and	w9, w9, w11, lsl #5
    1aa0: 0a180108     	and	w8, w8, w24
    1aa4: 2a080128     	orr	w8, w9, w8
    1aa8: b80046c8     	str	w8, [x22], #0x4
    1aac: 910063e0     	add	x0, sp, #0x18
    1ab0: 9400047c     	bl	0x2ca0 <_ZN7context15process_fix_mapEl@plt>
    1ab4: 91001294     	add	x20, x20, #0x4
    1ab8: 9100137b     	add	x27, x27, #0x4
    1abc: 710006bf     	cmp	w21, #0x1
    1ac0: 2a1303f5     	mov	w21, w19
    1ac4: 528000eb     	mov	w11, #0x7               // =7
    1ac8: 5280006c     	mov	w12, #0x3               // =3
    1acc: 54ffe4cc     	b.gt	0x1764 <_ZL18__fix_instructionsPjiS_+0xa4>
    1ad0: 14000103     	b	0x1edc <_ZL18__fix_instructionsPjiS_+0x81c>
    1ad4: 12081f08     	and	w8, w24, #0xff000000
    1ad8: 52bb0009     	mov	w9, #-0x28000000        // =-671088640
    1adc: 6b09011f     	cmp	w8, w9
    1ae0: 540000e1     	b.ne	0x1afc <_ZL18__fix_instructionsPjiS_+0x43c>
    1ae4: f9400fe8     	ldr	x8, [sp, #0x18]
    1ae8: cb080288     	sub	x8, x20, x8
    1aec: d342fd01     	lsr	x1, x8, #2
    1af0: 9b1a7028     	madd	x8, x1, x26, x28
    1af4: f9000916     	str	x22, [x8, #0x10]
    1af8: 17ffffed     	b	0x1aac <_ZL18__fix_instructionsPjiS_+0x3ec>
    1afc: 7202031f     	tst	w24, #0x40000000
    1b00: 52b7e00a     	mov	w10, #-0x41000000       // =-1090519040
    1b04: 9a8b0189     	csel	x9, x12, x11, eq
    1b08: 0a0a030a     	and	w10, w24, w10
    1b0c: 52a3000d     	mov	w13, #0x18000000        // =402653184
    1b10: 6b0d015f     	cmp	w10, w13
    1b14: 54000061     	b.ne	0x1b20 <_ZL18__fix_instructionsPjiS_+0x460>
    1b18: 12b7e00a     	mov	w10, #0x40ffffff        // =1090519039
    1b1c: 14000011     	b	0x1b60 <_ZL18__fix_instructionsPjiS_+0x4a0>
    1b20: 7100031f     	cmp	w24, #0x0
    1b24: 528001e9     	mov	w9, #0xf                // =15
    1b28: 9a89a189     	csel	x9, x12, x9, ge
    1b2c: 7202031f     	tst	w24, #0x40000000
    1b30: 9a8b0129     	csel	x9, x9, x11, eq
    1b34: 1208170a     	and	w10, w24, #0x3f000000
    1b38: 52a3800b     	mov	w11, #0x1c000000        // =469762048
    1b3c: 6b0b015f     	cmp	w10, w11
    1b40: 54000061     	b.ne	0x1b4c <_ZL18__fix_instructionsPjiS_+0x48c>
    1b44: 12a7e00a     	mov	w10, #-0x3f000001       // =-1056964609
    1b48: 14000006     	b	0x1b60 <_ZL18__fix_instructionsPjiS_+0x4a0>
    1b4c: 52b30009     	mov	w9, #-0x68000000        // =-1744830464
    1b50: 6b09011f     	cmp	w8, w9
    1b54: 54000981     	b.ne	0x1c84 <_ZL18__fix_instructionsPjiS_+0x5c4>
    1b58: 12bfe00a     	mov	w10, #0xffffff          // =16777215
    1b5c: 528000e9     	mov	w9, #0x7                // =7
    1b60: f9400feb     	ldr	x11, [sp, #0x18]
    1b64: 13035f0c     	sbfx	w12, w24, #3, #21
    1b68: 121e758c     	and	w12, w12, #0xfffffffc
    1b6c: 8b140181     	add	x1, x12, x20
    1b70: cb0b0288     	sub	x8, x20, x11
    1b74: eb01017f     	cmp	x11, x1
    1b78: d342fd0f     	lsr	x15, x8, #2
    1b7c: 9b1a71e8     	madd	x8, x15, x26, x28
    1b80: 91004108     	add	x8, x8, #0x10
    1b84: 5400008c     	b.gt	0x1b94 <_ZL18__fix_instructionsPjiS_+0x4d4>
    1b88: f94013eb     	ldr	x11, [sp, #0x20]
    1b8c: eb01017f     	cmp	x11, x1
    1b90: 5400014c     	b.gt	0x1bb8 <_ZL18__fix_instructionsPjiS_+0x4f8>
    1b94: cb16002b     	sub	x11, x1, x22
    1b98: d1000d2d     	sub	x13, x9, #0x3
    1b9c: 9342fd6b     	asr	x11, x11, #2
    1ba0: f100017f     	cmp	x11, #0x0
    1ba4: da8b556e     	cneg	x14, x11, mi
    1ba8: 8b4d09cd     	add	x13, x14, x13, lsr #2
    1bac: 12bfff8e     	mov	w14, #0x3ffff           // =262143
    1bb0: eb0e01bf     	cmp	x13, x14
    1bb4: 54000403     	b.lo	0x1c34 <_ZL18__fix_instructionsPjiS_+0x574>
    1bb8: 910022c0     	add	x0, x22, #0x8
    1bbc: a9005fef     	stp	x15, x23, [sp]
    1bc0: ea00013f     	tst	x9, x0
    1bc4: 54000160     	b.eq	0x1bf0 <_ZL18__fix_instructionsPjiS_+0x530>
    1bc8: 528403eb     	mov	w11, #0x201f            // =8223
    1bcc: 910032ca     	add	x10, x22, #0xc
    1bd0: 72baa06b     	movk	w11, #0xd503, lsl #16
    1bd4: ea0a013f     	tst	x9, x10
    1bd8: 9100114a     	add	x10, x10, #0x4
    1bdc: b80046cb     	str	w11, [x22], #0x4
    1be0: 54ffffa1     	b.ne	0x1bd4 <_ZL18__fix_instructionsPjiS_+0x514>
    1be4: aa1903f7     	mov	x23, x25
    1be8: 910022c0     	add	x0, x22, #0x8
    1bec: 14000002     	b	0x1bf4 <_ZL18__fix_instructionsPjiS_+0x534>
    1bf0: aa1903f7     	mov	x23, x25
    1bf4: 91000522     	add	x2, x9, #0x1
    1bf8: 5280006a     	mov	w10, #0x3               // =3
    1bfc: d342fc59     	lsr	x25, x2, #2
    1c00: 72a2800a     	movk	w10, #0x1400, lsl #16
    1c04: 12083309     	and	w9, w24, #0xff00001f
    1c08: 0b0a032a     	add	w10, w25, w10
    1c0c: 321a0129     	orr	w9, w9, #0x40
    1c10: 5100094a     	sub	w10, w10, #0x2
    1c14: f9000116     	str	x22, [x8]
    1c18: 29002ac9     	stp	w9, w10, [x22]
    1c1c: 94000425     	bl	0x2cb0 <memcpy@plt>
    1c20: 8b190ac8     	add	x8, x22, x25, lsl #2
    1c24: aa1703f9     	mov	x25, x23
    1c28: a9405fef     	ldp	x15, x23, [sp]
    1c2c: 91002116     	add	x22, x8, #0x8
    1c30: 14000012     	b	0x1c78 <_ZL18__fix_instructionsPjiS_+0x5b8>
    1c34: d342fd29     	lsr	x9, x9, #2
    1c38: ea0b013f     	tst	x9, x11
    1c3c: 54000140     	b.eq	0x1c64 <_ZL18__fix_instructionsPjiS_+0x5a4>
    1c40: 8b0c036b     	add	x11, x27, x12
    1c44: 528403ee     	mov	w14, #0x201f            // =8223
    1c48: cb16016c     	sub	x12, x11, x22
    1c4c: 72baa06e     	movk	w14, #0xd503, lsl #16
    1c50: 9342fd8b     	asr	x11, x12, #2
    1c54: d100118c     	sub	x12, x12, #0x4
    1c58: 8a09016d     	and	x13, x11, x9
    1c5c: b80046ce     	str	w14, [x22], #0x4
    1c60: b5ffff8d     	cbnz	x13, 0x1c50 <_ZL18__fix_instructionsPjiS_+0x590>
    1c64: 0a0b1549     	and	w9, w10, w11, lsl #5
    1c68: 1208330a     	and	w10, w24, #0xff00001f
    1c6c: 2a0a0129     	orr	w9, w9, w10
    1c70: f9000116     	str	x22, [x8]
    1c74: b80046c9     	str	w9, [x22], #0x4
    1c78: 910063e0     	add	x0, sp, #0x18
    1c7c: aa0f03e1     	mov	x1, x15
    1c80: 17ffff8c     	b	0x1ab0 <_ZL18__fix_instructionsPjiS_+0x3f0>
    1c84: 52b3e008     	mov	w8, #-0x61000000        // =-1627389952
    1c88: 52b20009     	mov	w9, #-0x70000000        // =-1879048192
    1c8c: 0a080308     	and	w8, w24, w8
    1c90: 6b09011f     	cmp	w8, w9
    1c94: 54000480     	b.eq	0x1d24 <_ZL18__fix_instructionsPjiS_+0x664>
    1c98: 52a20009     	mov	w9, #0x10000000         // =268435456
    1c9c: 6b09011f     	cmp	w8, w9
    1ca0: 54000781     	b.ne	0x1d90 <_ZL18__fix_instructionsPjiS_+0x6d0>
    1ca4: a941abe8     	ldp	x8, x10, [sp, #0x18]
    1ca8: 13035f09     	sbfx	w9, w24, #3, #21
    1cac: f90003f9     	str	x25, [sp]
    1cb0: 927e7529     	and	x9, x9, #0xfffffffc
    1cb4: b35d7b09     	bfxil	x9, x24, #29, #2
    1cb8: cb08028c     	sub	x12, x20, x8
    1cbc: 8b14012b     	add	x11, x9, x20
    1cc0: d342fd99     	lsr	x25, x12, #2
    1cc4: eb0b011f     	cmp	x8, x11
    1cc8: 1a9fc7ec     	cset	w12, le
    1ccc: eb0b015f     	cmp	x10, x11
    1cd0: cb160169     	sub	x9, x11, x22
    1cd4: 9b1a732a     	madd	x10, x25, x26, x28
    1cd8: 1a9fd7ed     	cset	w13, gt
    1cdc: f100013f     	cmp	x9, #0x0
    1ce0: 0a0d018c     	and	w12, w12, w13
    1ce4: da89552d     	cneg	x13, x9, mi
    1ce8: 7100059f     	cmp	w12, #0x1
    1cec: f9000beb     	str	x11, [sp, #0x10]
    1cf0: f8010d56     	str	x22, [x10, #0x10]!
    1cf4: 54000620     	b.eq	0x1db8 <_ZL18__fix_instructionsPjiS_+0x6f8>
    1cf8: 12bffe0e     	mov	w14, #0xfffff           // =1048575
    1cfc: eb0e01bf     	cmp	x13, x14
    1d00: 540005c3     	b.lo	0x1db8 <_ZL18__fix_instructionsPjiS_+0x6f8>
    1d04: 110022c8     	add	w8, w22, #0x8
    1d08: f240091f     	tst	x8, #0x7
    1d0c: 54000b00     	b.eq	0x1e6c <_ZL18__fix_instructionsPjiS_+0x7ac>
    1d10: 528403e8     	mov	w8, #0x201f             // =8223
    1d14: 72baa068     	movk	w8, #0xd503, lsl #16
    1d18: b80046c8     	str	w8, [x22], #0x4
    1d1c: f9000156     	str	x22, [x10]
    1d20: 14000053     	b	0x1e6c <_ZL18__fix_instructionsPjiS_+0x7ac>
    1d24: f9400fe9     	ldr	x9, [sp, #0x18]
    1d28: d343ff0a     	lsr	x10, x24, #3
    1d2c: 927e454a     	and	x10, x10, #0xffffc
    1d30: f90003f9     	str	x25, [sp]
    1d34: b35d7b0a     	bfxil	x10, x24, #29, #2
    1d38: 9274ce8b     	and	x11, x20, #0xfffffffffffff000
    1d3c: cb090288     	sub	x8, x20, x9
    1d40: d342fd19     	lsr	x25, x8, #2
    1d44: 8b0a316a     	add	x10, x11, x10, lsl #12
    1d48: eb090149     	subs	x9, x10, x9
    1d4c: 9b1a7328     	madd	x8, x25, x26, x28
    1d50: f9000bea     	str	x10, [sp, #0x10]
    1d54: f8010d16     	str	x22, [x8, #0x10]!
    1d58: 540007cb     	b.lt	0x1e50 <_ZL18__fix_instructionsPjiS_+0x790>
    1d5c: f94013eb     	ldr	x11, [sp, #0x20]
    1d60: eb0a017f     	cmp	x11, x10
    1d64: 5400076d     	b.le	0x1e50 <_ZL18__fix_instructionsPjiS_+0x790>
    1d68: eb490b3f     	cmp	x25, x9, lsr #2
    1d6c: 540000e2     	b.hs	0x1d88 <_ZL18__fix_instructionsPjiS_+0x6c8>
    1d70: f0ffffe1     	adrp	x1, 0x0 <vsnprintf>
    1d74: f0ffffe2     	adrp	x2, 0x0 <vsnprintf>
    1d78: 528000c0     	mov	w0, #0x6                // =6
    1d7c: 91330821     	add	x1, x1, #0xcc2
    1d80: 9134fc42     	add	x2, x2, #0xd3f
    1d84: 940003b7     	bl	0x2c60 <__android_log_print@plt>
    1d88: b80046d8     	str	w24, [x22], #0x4
    1d8c: 1400004e     	b	0x1ec4 <_ZL18__fix_instructionsPjiS_+0x804>
    1d90: f9400fe8     	ldr	x8, [sp, #0x18]
    1d94: 910063e0     	add	x0, sp, #0x18
    1d98: cb080288     	sub	x8, x20, x8
    1d9c: d342fd01     	lsr	x1, x8, #2
    1da0: 9b1a7028     	madd	x8, x1, x26, x28
    1da4: f9000916     	str	x22, [x8, #0x10]
    1da8: 940003be     	bl	0x2ca0 <_ZN7context15process_fix_mapEl@plt>
    1dac: b9400288     	ldr	w8, [x20]
    1db0: b80046c8     	str	w8, [x22], #0x4
    1db4: 17ffff40     	b	0x1ab4 <_ZL18__fix_instructionsPjiS_+0x3f4>
    1db8: 340007ec     	cbz	w12, 0x1eb4 <_ZL18__fix_instructionsPjiS_+0x7f4>
    1dbc: 927ef569     	and	x9, x11, #0xfffffffffffffffc
    1dc0: cb080128     	sub	x8, x9, x8
    1dc4: d342fd09     	lsr	x9, x8, #2
    1dc8: eb19013f     	cmp	x9, x25
    1dcc: 54000669     	b.ls	0x1e98 <_ZL18__fix_instructionsPjiS_+0x7d8>
    1dd0: 9b1a7128     	madd	x8, x9, x26, x28
    1dd4: f8418d0a     	ldr	x10, [x8, #0x18]!
    1dd8: b400068a     	cbz	x10, 0x1ea8 <_ZL18__fix_instructionsPjiS_+0x7e8>
    1ddc: 9b1a7128     	madd	x8, x9, x26, x28
    1de0: f8428d0a     	ldr	x10, [x8, #0x28]!
    1de4: b400062a     	cbz	x10, 0x1ea8 <_ZL18__fix_instructionsPjiS_+0x7e8>
    1de8: 9b1a7128     	madd	x8, x9, x26, x28
    1dec: f8438d0a     	ldr	x10, [x8, #0x38]!
    1df0: b40005ca     	cbz	x10, 0x1ea8 <_ZL18__fix_instructionsPjiS_+0x7e8>
    1df4: 9b1a7128     	madd	x8, x9, x26, x28
    1df8: f8448d0a     	ldr	x10, [x8, #0x48]!
    1dfc: b400056a     	cbz	x10, 0x1ea8 <_ZL18__fix_instructionsPjiS_+0x7e8>
    1e00: 9b1a7128     	madd	x8, x9, x26, x28
    1e04: f8458d0a     	ldr	x10, [x8, #0x58]!
    1e08: b400050a     	cbz	x10, 0x1ea8 <_ZL18__fix_instructionsPjiS_+0x7e8>
    1e0c: 9b1a7128     	madd	x8, x9, x26, x28
    1e10: f8468d0a     	ldr	x10, [x8, #0x68]!
    1e14: b40004aa     	cbz	x10, 0x1ea8 <_ZL18__fix_instructionsPjiS_+0x7e8>
    1e18: 9b1a7128     	madd	x8, x9, x26, x28
    1e1c: f8478d0a     	ldr	x10, [x8, #0x78]!
    1e20: b400044a     	cbz	x10, 0x1ea8 <_ZL18__fix_instructionsPjiS_+0x7e8>
    1e24: 9b1a7128     	madd	x8, x9, x26, x28
    1e28: f8488d0a     	ldr	x10, [x8, #0x88]!
    1e2c: b40003ea     	cbz	x10, 0x1ea8 <_ZL18__fix_instructionsPjiS_+0x7e8>
    1e30: 9b1a7128     	madd	x8, x9, x26, x28
    1e34: f8498d0a     	ldr	x10, [x8, #0x98]!
    1e38: b400038a     	cbz	x10, 0x1ea8 <_ZL18__fix_instructionsPjiS_+0x7e8>
    1e3c: 9b1a7128     	madd	x8, x9, x26, x28
    1e40: f84a8d09     	ldr	x9, [x8, #0xa8]!
    1e44: b4000329     	cbz	x9, 0x1ea8 <_ZL18__fix_instructionsPjiS_+0x7e8>
    1e48: aa1f03e9     	mov	x9, xzr
    1e4c: 1400001a     	b	0x1eb4 <_ZL18__fix_instructionsPjiS_+0x7f4>
    1e50: 110022c9     	add	w9, w22, #0x8
    1e54: f240093f     	tst	x9, #0x7
    1e58: 540000a0     	b.eq	0x1e6c <_ZL18__fix_instructionsPjiS_+0x7ac>
    1e5c: 528403e9     	mov	w9, #0x201f             // =8223
    1e60: 72baa069     	movk	w9, #0xd503, lsl #16
    1e64: b80046c9     	str	w9, [x22], #0x4
    1e68: f9000116     	str	x22, [x8]
    1e6c: 52800808     	mov	w8, #0x40               // =64
    1e70: f9400be9     	ldr	x9, [sp, #0x10]
    1e74: 72ab0008     	movk	w8, #0x5800, lsl #16
    1e78: 33001308     	bfxil	w8, w24, #0, #5
    1e7c: f90006c9     	str	x9, [x22, #0x8]
    1e80: b90002c8     	str	w8, [x22]
    1e84: 52800068     	mov	w8, #0x3                // =3
    1e88: 72a28008     	movk	w8, #0x1400, lsl #16
    1e8c: b90006c8     	str	w8, [x22, #0x4]
    1e90: 910042d6     	add	x22, x22, #0x10
    1e94: 1400000c     	b	0x1ec4 <_ZL18__fix_instructionsPjiS_+0x804>
    1e98: 9b1a7128     	madd	x8, x9, x26, x28
    1e9c: f9400908     	ldr	x8, [x8, #0x10]
    1ea0: cb160109     	sub	x9, x8, x22
    1ea4: 14000004     	b	0x1eb4 <_ZL18__fix_instructionsPjiS_+0x7f4>
    1ea8: aa1f03e9     	mov	x9, xzr
    1eac: f9000116     	str	x22, [x8]
    1eb0: fd00050c     	str	d12, [x8, #0x8]
    1eb4: 531d5128     	ubfiz	w8, w9, #3, #21
    1eb8: 12083309     	and	w9, w24, #0xff00001f
    1ebc: 2a090108     	orr	w8, w8, w9
    1ec0: b80046c8     	str	w8, [x22], #0x4
    1ec4: 910063e0     	add	x0, sp, #0x18
    1ec8: aa1903e1     	mov	x1, x25
    1ecc: 94000375     	bl	0x2ca0 <_ZN7context15process_fix_mapEl@plt>
    1ed0: f94003f9     	ldr	x25, [sp]
    1ed4: 17fffef8     	b	0x1ab4 <_ZL18__fix_instructionsPjiS_+0x3f4>
    1ed8: aa1703f6     	mov	x22, x23
    1edc: cb160288     	sub	x8, x20, x22
    1ee0: 12bfc00a     	mov	w10, #0x1ffffff         // =33554431
    1ee4: 9342fd09     	asr	x9, x8, #2
    1ee8: f100013f     	cmp	x9, #0x0
    1eec: da895529     	cneg	x9, x9, mi
    1ef0: eb0a013f     	cmp	x9, x10
    1ef4: 54000183     	b.lo	0x1f24 <_ZL18__fix_instructionsPjiS_+0x864>
    1ef8: f0ffffe9     	adrp	x9, 0x0 <vsnprintf>
    1efc: 110022c8     	add	w8, w22, #0x8
    1f00: f240091f     	tst	x8, #0x7
    1f04: 54000080     	b.eq	0x1f14 <_ZL18__fix_instructionsPjiS_+0x854>
    1f08: 528403e8     	mov	w8, #0x201f             // =8223
    1f0c: 72baa068     	movk	w8, #0xd503, lsl #16
    1f10: b80046c8     	str	w8, [x22], #0x4
    1f14: fd452d20     	ldr	d0, [x9, #0xa58]
    1f18: f90006d4     	str	x20, [x22, #0x8]
    1f1c: fc0106c0     	str	d0, [x22], #0x10
    1f20: 14000004     	b	0x1f30 <_ZL18__fix_instructionsPjiS_+0x870>
    1f24: 52a28009     	mov	w9, #0x14000000         // =335544320
    1f28: 33026d09     	bfxil	w9, w8, #2, #26
    1f2c: b80046c9     	str	w9, [x22], #0x4
    1f30: aa1703e0     	mov	x0, x23
    1f34: aa1603e1     	mov	x1, x22
    1f38: 940002c5     	bl	0x2a4c <__clear_cache>
    1f3c: f9401728     	ldr	x8, [x25, #0x28]
    1f40: f85c03a9     	ldur	x9, [x29, #-0x40]
    1f44: eb09011f     	cmp	x8, x9
    1f48: 54000181     	b.ne	0x1f78 <_ZL18__fix_instructionsPjiS_+0x8b8>
    1f4c: 910e03ff     	add	sp, sp, #0x380
    1f50: a9484ff4     	ldp	x20, x19, [sp, #0x80]
    1f54: a94757f6     	ldp	x22, x21, [sp, #0x70]
    1f58: a9465ff8     	ldp	x24, x23, [sp, #0x60]
    1f5c: a94567fa     	ldp	x26, x25, [sp, #0x50]
    1f60: a9446ffc     	ldp	x28, x27, [sp, #0x40]
    1f64: a9437bfd     	ldp	x29, x30, [sp, #0x30]
    1f68: 6d4223e9     	ldp	d9, d8, [sp, #0x20]
    1f6c: 6d412beb     	ldp	d11, d10, [sp, #0x10]
    1f70: fc4907ec     	ldr	d12, [sp], #0x90
    1f74: d65f03c0     	ret
    1f78: 94000352     	bl	0x2cc0 <__stack_chk_fail@plt>

0000000000001f7c <A64HookFunction>:
    1f7c: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
    1f80: a90157f6     	stp	x22, x21, [sp, #0x10]
    1f84: 910003fd     	mov	x29, sp
    1f88: a9024ff4     	stp	x20, x19, [sp, #0x20]
    1f8c: aa0203f3     	mov	x19, x2
    1f90: aa0103f4     	mov	x20, x1
    1f94: aa0003f5     	mov	x21, x0
    1f98: b40001c2     	cbz	x2, 0x1fd0 <A64HookFunction+0x54>
    1f9c: d0000041     	adrp	x1, 0xb000 <vsnprintf+0xb000>
    1fa0: 52800020     	mov	w0, #0x1                // =1
    1fa4: 91018021     	add	x1, x1, #0x60
    1fa8: 9400030e     	bl	0x2be0 <__aarch64_ldadd4_acq_rel>
    1fac: 11000408     	add	w8, w0, #0x1
    1fb0: 7104011f     	cmp	w8, #0x100
    1fb4: 540003e2     	b.hs	0x2030 <A64HookFunction+0xb4>
    1fb8: 52801909     	mov	w9, #0xc8               // =200
    1fbc: f000004a     	adrp	x10, 0xc000 <_ZL12__insns_pool>
    1fc0: 9100014a     	add	x10, x10, #0x0
    1fc4: 9ba92916     	umaddl	x22, w8, w9, x10
    1fc8: f9000276     	str	x22, [x19]
    1fcc: 14000002     	b	0x1fd4 <A64HookFunction+0x58>
    1fd0: aa1f03f6     	mov	x22, xzr
    1fd4: 528204e8     	mov	w8, #0x1027             // =4135
    1fd8: 913ffea9     	add	x9, x21, #0xfff
    1fdc: 8b0802a8     	add	x8, x21, x8
    1fe0: 9274cea0     	and	x0, x21, #0xfffffffffffff000
    1fe4: ca090108     	eor	x8, x8, x9
    1fe8: 52820009     	mov	w9, #0x1000             // =4096
    1fec: f140051f     	cmp	x8, #0x1, lsl #12       // =0x1000
    1ff0: 52840008     	mov	w8, #0x2000             // =8192
    1ff4: 9a883121     	csel	x1, x9, x8, lo
    1ff8: 528000e2     	mov	w2, #0x7                // =7
    1ffc: 9400031d     	bl	0x2c70 <mprotect@plt>
    2000: aa1503e0     	mov	x0, x21
    2004: aa1403e1     	mov	x1, x20
    2008: aa1603e2     	mov	x2, x22
    200c: 52800643     	mov	w3, #0x32               // =50
    2010: 94000310     	bl	0x2c50 <A64HookFunctionV@plt>
    2014: b4000073     	cbz	x19, 0x2020 <A64HookFunction+0xa4>
    2018: b5000040     	cbnz	x0, 0x2020 <A64HookFunction+0xa4>
    201c: f900027f     	str	xzr, [x19]
    2020: a9424ff4     	ldp	x20, x19, [sp, #0x20]
    2024: a94157f6     	ldp	x22, x21, [sp, #0x10]
    2028: a8c37bfd     	ldp	x29, x30, [sp], #0x30
    202c: d65f03c0     	ret
    2030: d0ffffe1     	adrp	x1, 0x0 <vsnprintf>
    2034: d0ffffe2     	adrp	x2, 0x0 <vsnprintf>
    2038: 91330821     	add	x1, x1, #0xcc2
    203c: 912b8842     	add	x2, x2, #0xae2
    2040: 528000c0     	mov	w0, #0x6                // =6
    2044: 94000307     	bl	0x2c60 <__android_log_print@plt>
    2048: 17fffff5     	b	0x201c <A64HookFunction+0xa0>

000000000000204c <_ZN7context15process_fix_mapEl>:
    204c: 52801508     	mov	w8, #0xa8               // =168
    2050: 9b08002a     	madd	x10, x1, x8, x0
    2054: f8418d4c     	ldr	x12, [x10, #0x18]!
    2058: b40012cc     	cbz	x12, 0x22b0 <_ZN7context15process_fix_mapEl+0x264>
    205c: 52801509     	mov	w9, #0xa8               // =168
    2060: d1002148     	sub	x8, x10, #0x8
    2064: b9400190     	ldr	w16, [x12]
    2068: f900015f     	str	xzr, [x10]
    206c: d503201f     	nop
    2070: 9b090029     	madd	x9, x1, x9, x0
    2074: b940010d     	ldr	w13, [x8]
    2078: f8428d2b     	ldr	x11, [x9, #0x28]!
    207c: 297f3d2e     	ldp	w14, w15, [x9, #-0x8]
    2080: 4b0c01ad     	sub	w13, w13, w12
    2084: 13027dad     	asr	w13, w13, #2
    2088: 1ace21ad     	lsl	w13, w13, w14
    208c: 0a0f01ad     	and	w13, w13, w15
    2090: 2a1001ad     	orr	w13, w13, w16
    2094: b900018d     	str	w13, [x12]
    2098: b40010cb     	cbz	x11, 0x22b0 <_ZN7context15process_fix_mapEl+0x264>
    209c: 5280150a     	mov	w10, #0xa8              // =168
    20a0: b940010d     	ldr	w13, [x8]
    20a4: b9400170     	ldr	w16, [x11]
    20a8: f900013f     	str	xzr, [x9]
    20ac: d503201f     	nop
    20b0: 9b0a002a     	madd	x10, x1, x10, x0
    20b4: 4b0b01ad     	sub	w13, w13, w11
    20b8: 13027dad     	asr	w13, w13, #2
    20bc: f8438d4c     	ldr	x12, [x10, #0x38]!
    20c0: 297f3d4e     	ldp	w14, w15, [x10, #-0x8]
    20c4: 1ace21ad     	lsl	w13, w13, w14
    20c8: 0a0f01ad     	and	w13, w13, w15
    20cc: 2a1001ad     	orr	w13, w13, w16
    20d0: b900016d     	str	w13, [x11]
    20d4: b4000eec     	cbz	x12, 0x22b0 <_ZN7context15process_fix_mapEl+0x264>
    20d8: 52801509     	mov	w9, #0xa8               // =168
    20dc: b940010d     	ldr	w13, [x8]
    20e0: b9400190     	ldr	w16, [x12]
    20e4: f900015f     	str	xzr, [x10]
    20e8: d503201f     	nop
    20ec: 9b090029     	madd	x9, x1, x9, x0
    20f0: 4b0c01ad     	sub	w13, w13, w12
    20f4: 13027dad     	asr	w13, w13, #2
    20f8: f8448d2b     	ldr	x11, [x9, #0x48]!
    20fc: 297f3d2e     	ldp	w14, w15, [x9, #-0x8]
    2100: 1ace21ad     	lsl	w13, w13, w14
    2104: 0a0f01ad     	and	w13, w13, w15
    2108: 2a1001ad     	orr	w13, w13, w16
    210c: b900018d     	str	w13, [x12]
    2110: b4000d0b     	cbz	x11, 0x22b0 <_ZN7context15process_fix_mapEl+0x264>
    2114: 5280150a     	mov	w10, #0xa8              // =168
    2118: b940010d     	ldr	w13, [x8]
    211c: b9400170     	ldr	w16, [x11]
    2120: f900013f     	str	xzr, [x9]
    2124: d503201f     	nop
    2128: 9b0a002a     	madd	x10, x1, x10, x0
    212c: 4b0b01ad     	sub	w13, w13, w11
    2130: 13027dad     	asr	w13, w13, #2
    2134: f8458d4c     	ldr	x12, [x10, #0x58]!
    2138: 297f3d4e     	ldp	w14, w15, [x10, #-0x8]
    213c: 1ace21ad     	lsl	w13, w13, w14
    2140: 0a0f01ad     	and	w13, w13, w15
    2144: 2a1001ad     	orr	w13, w13, w16
    2148: b900016d     	str	w13, [x11]
    214c: b4000b2c     	cbz	x12, 0x22b0 <_ZN7context15process_fix_mapEl+0x264>
    2150: 52801509     	mov	w9, #0xa8               // =168
    2154: b940010d     	ldr	w13, [x8]
    2158: b9400190     	ldr	w16, [x12]
    215c: f900015f     	str	xzr, [x10]
    2160: d503201f     	nop
    2164: 9b090029     	madd	x9, x1, x9, x0
    2168: 4b0c01ad     	sub	w13, w13, w12
    216c: 13027dad     	asr	w13, w13, #2
    2170: f8468d2b     	ldr	x11, [x9, #0x68]!
    2174: 297f3d2e     	ldp	w14, w15, [x9, #-0x8]
    2178: 1ace21ad     	lsl	w13, w13, w14
    217c: 0a0f01ad     	and	w13, w13, w15
    2180: 2a1001ad     	orr	w13, w13, w16
    2184: b900018d     	str	w13, [x12]
    2188: b400094b     	cbz	x11, 0x22b0 <_ZN7context15process_fix_mapEl+0x264>
    218c: 5280150a     	mov	w10, #0xa8              // =168
    2190: b940010d     	ldr	w13, [x8]
    2194: b9400170     	ldr	w16, [x11]
    2198: f900013f     	str	xzr, [x9]
    219c: d503201f     	nop
    21a0: 9b0a002a     	madd	x10, x1, x10, x0
    21a4: 4b0b01ad     	sub	w13, w13, w11
    21a8: 13027dad     	asr	w13, w13, #2
    21ac: f8478d4c     	ldr	x12, [x10, #0x78]!
    21b0: 297f3d4e     	ldp	w14, w15, [x10, #-0x8]
    21b4: 1ace21ad     	lsl	w13, w13, w14
    21b8: 0a0f01ad     	and	w13, w13, w15
    21bc: 2a1001ad     	orr	w13, w13, w16
    21c0: b900016d     	str	w13, [x11]
    21c4: b400076c     	cbz	x12, 0x22b0 <_ZN7context15process_fix_mapEl+0x264>
    21c8: 52801509     	mov	w9, #0xa8               // =168
    21cc: b940010d     	ldr	w13, [x8]
    21d0: b9400190     	ldr	w16, [x12]
    21d4: f900015f     	str	xzr, [x10]
    21d8: d503201f     	nop
    21dc: 9b090029     	madd	x9, x1, x9, x0
    21e0: 4b0c01ad     	sub	w13, w13, w12
    21e4: 13027dad     	asr	w13, w13, #2
    21e8: f8488d2b     	ldr	x11, [x9, #0x88]!
    21ec: 297f3d2e     	ldp	w14, w15, [x9, #-0x8]
    21f0: 1ace21ad     	lsl	w13, w13, w14
    21f4: 0a0f01ad     	and	w13, w13, w15
    21f8: 2a1001ad     	orr	w13, w13, w16
    21fc: b900018d     	str	w13, [x12]
    2200: b400058b     	cbz	x11, 0x22b0 <_ZN7context15process_fix_mapEl+0x264>
    2204: 5280150a     	mov	w10, #0xa8              // =168
    2208: b940010d     	ldr	w13, [x8]
    220c: b9400170     	ldr	w16, [x11]
    2210: f900013f     	str	xzr, [x9]
    2214: d503201f     	nop
    2218: 9b0a002a     	madd	x10, x1, x10, x0
    221c: 4b0b01ad     	sub	w13, w13, w11
    2220: 13027dad     	asr	w13, w13, #2
    2224: f8498d4c     	ldr	x12, [x10, #0x98]!
    2228: 297f3d4e     	ldp	w14, w15, [x10, #-0x8]
    222c: 1ace21ad     	lsl	w13, w13, w14
    2230: 0a0f01ad     	and	w13, w13, w15
    2234: 2a1001ad     	orr	w13, w13, w16
    2238: b900016d     	str	w13, [x11]
    223c: b40003ac     	cbz	x12, 0x22b0 <_ZN7context15process_fix_mapEl+0x264>
    2240: 52801509     	mov	w9, #0xa8               // =168
    2244: b940010d     	ldr	w13, [x8]
    2248: b9400190     	ldr	w16, [x12]
    224c: f900015f     	str	xzr, [x10]
    2250: d503201f     	nop
    2254: 9b090029     	madd	x9, x1, x9, x0
    2258: 4b0c01ad     	sub	w13, w13, w12
    225c: 13027dad     	asr	w13, w13, #2
    2260: f84a8d2b     	ldr	x11, [x9, #0xa8]!
    2264: 297f3d2e     	ldp	w14, w15, [x9, #-0x8]
    2268: 1ace21ad     	lsl	w13, w13, w14
    226c: 0a0f01ad     	and	w13, w13, w15
    2270: 2a1001ad     	orr	w13, w13, w16
    2274: b900018d     	str	w13, [x12]
    2278: b40001cb     	cbz	x11, 0x22b0 <_ZN7context15process_fix_mapEl+0x264>
    227c: 5280150a     	mov	w10, #0xa8              // =168
    2280: b9400108     	ldr	w8, [x8]
    2284: b940016d     	ldr	w13, [x11]
    2288: f900013f     	str	xzr, [x9]
    228c: d503201f     	nop
    2290: 9b0a002a     	madd	x10, x1, x10, x0
    2294: 4b0b0108     	sub	w8, w8, w11
    2298: 13027d08     	asr	w8, w8, #2
    229c: 2956294c     	ldp	w12, w10, [x10, #0xb0]
    22a0: 1acc2108     	lsl	w8, w8, w12
    22a4: 0a0a0108     	and	w8, w8, w10
    22a8: 2a0d0108     	orr	w8, w8, w13
    22ac: b9000168     	str	w8, [x11]
    22b0: d65f03c0     	ret

00000000000022b4 <_GLOBAL__sub_I_And64InlineHook.cpp>:
    22b4: d0000040     	adrp	x0, 0xc000 <_ZL12__insns_pool>
    22b8: 529affe8     	mov	w8, #0xd7ff             // =55295
    22bc: 91000000     	add	x0, x0, #0x0
    22c0: 528000e2     	mov	w2, #0x7                // =7
    22c4: 8b080008     	add	x8, x0, x8
    22c8: 913ffc09     	add	x9, x0, #0xfff
    22cc: 9274cd08     	and	x8, x8, #0xfffffffffffff000
    22d0: 9274cd29     	and	x9, x9, #0xfffffffffffff000
    22d4: eb09011f     	cmp	x8, x9
    22d8: 529a0008     	mov	w8, #0xd000             // =53248
    22dc: 529c0009     	mov	w9, #0xe000             // =57344
    22e0: 9a881121     	csel	x1, x9, x8, ne
    22e4: 14000263     	b	0x2c70 <mprotect@plt>

00000000000022e8 <auto_start>:
    22e8: d100c3ff     	sub	sp, sp, #0x30
    22ec: a9017bfd     	stp	x29, x30, [sp, #0x10]
    22f0: 910043fd     	add	x29, sp, #0x10
    22f4: f90013f3     	str	x19, [sp, #0x20]
    22f8: d53bd053     	mrs	x19, TPIDR_EL0
    22fc: 90000002     	adrp	x2, 0x2000 <A64HookFunction+0x84>
    2300: f9401668     	ldr	x8, [x19, #0x28]
    2304: 910e3042     	add	x2, x2, #0x38c
    2308: 910003e0     	mov	x0, sp
    230c: aa1f03e1     	mov	x1, xzr
    2310: aa1f03e3     	mov	x3, xzr
    2314: f90007e8     	str	x8, [sp, #0x8]
    2318: 94000272     	bl	0x2ce0 <pthread_create@plt>
    231c: 340002a0     	cbz	w0, 0x2370 <auto_start+0x88>
    2320: d0ffffe3     	adrp	x3, 0x0 <vsnprintf>
    2324: 2a0003e4     	mov	w4, w0
    2328: 912ae863     	add	x3, x3, #0xaba
    232c: 94000098     	bl	0x258c <_ZL8snprintfPcU17pass_object_size1mPKcz>
    2330: d0ffffe1     	adrp	x1, 0x0 <vsnprintf>
    2334: d0ffffe2     	adrp	x2, 0x0 <vsnprintf>
    2338: d00000a3     	adrp	x3, 0x18000 <_ZL12__insns_pool+0xc000>
    233c: 9129e021     	add	x1, x1, #0xa78
    2340: 912b5042     	add	x2, x2, #0xad4
    2344: 91204063     	add	x3, x3, #0x810
    2348: 528000c0     	mov	w0, #0x6                // =6
    234c: 94000245     	bl	0x2c60 <__android_log_print@plt>
    2350: f9401668     	ldr	x8, [x19, #0x28]
    2354: f94007e9     	ldr	x9, [sp, #0x8]
    2358: eb09011f     	cmp	x8, x9
    235c: 54000161     	b.ne	0x2388 <auto_start+0xa0>
    2360: a9417bfd     	ldp	x29, x30, [sp, #0x10]
    2364: f94013f3     	ldr	x19, [sp, #0x20]
    2368: 9100c3ff     	add	sp, sp, #0x30
    236c: d65f03c0     	ret
    2370: f94003e0     	ldr	x0, [sp]
    2374: 9400025f     	bl	0x2cf0 <pthread_detach@plt>
    2378: f9401668     	ldr	x8, [x19, #0x28]
    237c: f94007e9     	ldr	x9, [sp, #0x8]
    2380: eb09011f     	cmp	x8, x9
    2384: 54fffee0     	b.eq	0x2360 <auto_start+0x78>
    2388: 9400024e     	bl	0x2cc0 <__stack_chk_fail@plt>

000000000000238c <auto_install_worker>:
    238c: d10283ff     	sub	sp, sp, #0xa0
    2390: a9067bfd     	stp	x29, x30, [sp, #0x60]
    2394: 910183fd     	add	x29, sp, #0x60
    2398: f9003bf7     	str	x23, [sp, #0x70]
    239c: a90857f6     	stp	x22, x21, [sp, #0x80]
    23a0: a9094ff4     	stp	x20, x19, [sp, #0x90]
    23a4: f0ffffe8     	adrp	x8, 0x1000 <kCnOriginal+0x4de>
    23a8: d53bd055     	mrs	x21, TPIDR_EL0
    23ac: 91014108     	add	x8, x8, #0x50
    23b0: f94016a9     	ldr	x9, [x21, #0x28]
    23b4: 910083e0     	add	x0, sp, #0x20
    23b8: aa1f03e1     	mov	x1, xzr
    23bc: 3dc00100     	ldr	q0, [x8]
    23c0: f81f83a9     	stur	x9, [x29, #-0x8]
    23c4: 3d800be0     	str	q0, [sp, #0x20]
    23c8: 9400024e     	bl	0x2d00 <nanosleep@plt>
    23cc: d00000b3     	adrp	x19, 0x18000 <_ZL12__insns_pool+0xc000>
    23d0: 91200273     	add	x19, x19, #0x800
    23d4: 88dffe68     	ldar	w8, [x19]
    23d8: 7100091f     	cmp	w8, #0x2
    23dc: 540009c0     	b.eq	0x2514 <auto_install_worker+0x188>
    23e0: 37f809a8     	tbnz	w8, #0x1f, 0x2514 <auto_install_worker+0x188>
    23e4: 90000028     	adrp	x8, 0x6000 <strncmp@plt+0x3290>
    23e8: d281ffd6     	mov	x22, #0xffe             // =4094
    23ec: 91362108     	add	x8, x8, #0xd88
    23f0: f2bf03b6     	movk	x22, #0xf81d, lsl #16
    23f4: f2cafed6     	movk	x22, #0x57f6, lsl #32
    23f8: 5289fe97     	mov	w23, #0x4ff4            // =20468
    23fc: 90000014     	adrp	x20, 0x2000 <A64HookFunction+0x84>
    2400: f2f52036     	movk	x22, #0xa901, lsl #48
    2404: ad400101     	ldp	q1, q0, [x8]
    2408: 72b52057     	movk	w23, #0xa902, lsl #16
    240c: 9118c294     	add	x20, x20, #0x630
    2410: ad0007e0     	stp	q0, q1, [sp]
    2414: ad4007e0     	ldp	q0, q1, [sp]
    2418: 9100c3e1     	add	x1, sp, #0x30
    241c: aa1403e0     	mov	x0, x20
    2420: ad0183e1     	stp	q1, q0, [sp, #0x30]
    2424: 9400023b     	bl	0x2d10 <dl_iterate_phdr@plt>
    2428: 394123e8     	ldrb	w8, [sp, #0x48]
    242c: 34000248     	cbz	w8, 0x2474 <auto_install_worker+0xe8>
    2430: 394127e8     	ldrb	w8, [sp, #0x49]
    2434: 34000308     	cbz	w8, 0x2494 <auto_install_worker+0x108>
    2438: f94023e8     	ldr	x8, [sp, #0x40]
    243c: f9400109     	ldr	x9, [x8]
    2440: b9400908     	ldr	w8, [x8, #0x8]
    2444: ca160129     	eor	x9, x9, x22
    2448: ca170108     	eor	x8, x8, x23
    244c: aa080128     	orr	x8, x9, x8
    2450: b5000228     	cbnz	x8, 0x2494 <auto_install_worker+0x108>
    2454: 2a1f03e0     	mov	w0, wzr
    2458: 52800021     	mov	w1, #0x1                // =1
    245c: aa1303e2     	mov	x2, x19
    2460: 940001a0     	bl	0x2ae0 <__aarch64_cas4_acq_rel>
    2464: 7100001f     	cmp	w0, #0x0
    2468: 540002e0     	b.eq	0x24c4 <auto_install_worker+0x138>
    246c: 7100081f     	cmp	w0, #0x2
    2470: 54000520     	b.eq	0x2514 <auto_install_worker+0x188>
    2474: 910083e0     	add	x0, sp, #0x20
    2478: aa1f03e1     	mov	x1, xzr
    247c: 94000221     	bl	0x2d00 <nanosleep@plt>
    2480: 88dffe68     	ldar	w8, [x19]
    2484: 7100091f     	cmp	w8, #0x2
    2488: 54000460     	b.eq	0x2514 <auto_install_worker+0x188>
    248c: 36fffc48     	tbz	w8, #0x1f, 0x2414 <auto_install_worker+0x88>
    2490: 14000021     	b	0x2514 <auto_install_worker+0x188>
    2494: d0ffffe3     	adrp	x3, 0x0 <vsnprintf>
    2498: d0ffffe4     	adrp	x4, 0x0 <vsnprintf>
    249c: 912b5063     	add	x3, x3, #0xad4
    24a0: 9135c884     	add	x4, x4, #0xd72
    24a4: 9400003a     	bl	0x258c <_ZL8snprintfPcU17pass_object_size1mPKcz>
    24a8: 12800028     	mov	w8, #-0x2               // =-2
    24ac: 889ffe68     	stlr	w8, [x19]
    24b0: f94016a8     	ldr	x8, [x21, #0x28]
    24b4: f85f83a9     	ldur	x9, [x29, #-0x8]
    24b8: eb09011f     	cmp	x8, x9
    24bc: 54000340     	b.eq	0x2524 <auto_install_worker+0x198>
    24c0: 14000032     	b	0x2588 <auto_install_worker+0x1fc>
    24c4: d00000b4     	adrp	x20, 0x18000 <_ZL12__insns_pool+0xc000>
    24c8: 90000001     	adrp	x1, 0x2000 <A64HookFunction+0x84>
    24cc: 91202294     	add	x20, x20, #0x808
    24d0: f94023e0     	ldr	x0, [sp, #0x40]
    24d4: 911cd021     	add	x1, x1, #0x734
    24d8: aa1403e2     	mov	x2, x20
    24dc: 940001fd     	bl	0x2cd0 <A64HookFunction@plt>
    24e0: f9400288     	ldr	x8, [x20]
    24e4: b40002e8     	cbz	x8, 0x2540 <auto_install_worker+0x1b4>
    24e8: 52800048     	mov	w8, #0x2                // =2
    24ec: d0ffffe1     	adrp	x1, 0x0 <vsnprintf>
    24f0: d0ffffe2     	adrp	x2, 0x0 <vsnprintf>
    24f4: 529b1584     	mov	w4, #0xd8ac             // =55468
    24f8: 9129e021     	add	x1, x1, #0xa78
    24fc: 91332c42     	add	x2, x2, #0xccb
    2500: 889ffe68     	stlr	w8, [x19]
    2504: 52800080     	mov	w0, #0x4                // =4
    2508: a94397e3     	ldp	x3, x5, [sp, #0x38]
    250c: 72a27a04     	movk	w4, #0x13d0, lsl #16
    2510: 940001d4     	bl	0x2c60 <__android_log_print@plt>
    2514: f94016a8     	ldr	x8, [x21, #0x28]
    2518: f85f83a9     	ldur	x9, [x29, #-0x8]
    251c: eb09011f     	cmp	x8, x9
    2520: 54000341     	b.ne	0x2588 <auto_install_worker+0x1fc>
    2524: a9494ff4     	ldp	x20, x19, [sp, #0x90]
    2528: aa1f03e0     	mov	x0, xzr
    252c: a94857f6     	ldp	x22, x21, [sp, #0x80]
    2530: a9467bfd     	ldp	x29, x30, [sp, #0x60]
    2534: f9403bf7     	ldr	x23, [sp, #0x70]
    2538: 910283ff     	add	sp, sp, #0xa0
    253c: d65f03c0     	ret
    2540: d0fffff4     	adrp	x20, 0x0 <vsnprintf>
    2544: d0ffffe4     	adrp	x4, 0x0 <vsnprintf>
    2548: 912b5294     	add	x20, x20, #0xad4
    254c: 9136d484     	add	x4, x4, #0xdb5
    2550: aa1403e3     	mov	x3, x20
    2554: 9400000e     	bl	0x258c <_ZL8snprintfPcU17pass_object_size1mPKcz>
    2558: d0ffffe1     	adrp	x1, 0x0 <vsnprintf>
    255c: 12800048     	mov	w8, #-0x3               // =-3
    2560: 91004263     	add	x3, x19, #0x10
    2564: 9129e021     	add	x1, x1, #0xa78
    2568: 528000c0     	mov	w0, #0x6                // =6
    256c: aa1403e2     	mov	x2, x20
    2570: 889ffe68     	stlr	w8, [x19]
    2574: 940001bb     	bl	0x2c60 <__android_log_print@plt>
    2578: f94016a8     	ldr	x8, [x21, #0x28]
    257c: f85f83a9     	ldur	x9, [x29, #-0x8]
    2580: eb09011f     	cmp	x8, x9
    2584: 54fffd00     	b.eq	0x2524 <auto_install_worker+0x198>
    2588: 940001ce     	bl	0x2cc0 <__stack_chk_fail@plt>

000000000000258c <_ZL8snprintfPcU17pass_object_size1mPKcz>:
    258c: d10443ff     	sub	sp, sp, #0x110
    2590: a90f7bfd     	stp	x29, x30, [sp, #0xf0]
    2594: 9103c3fd     	add	x29, sp, #0xf0
    2598: a9104ffc     	stp	x28, x19, [sp, #0x100]
    259c: ad0007e0     	stp	q0, q1, [sp]
    25a0: d101c3a9     	sub	x9, x29, #0x70
    25a4: a9399ba5     	stp	x5, x6, [x29, #-0x68]
    25a8: 928003eb     	mov	x11, #-0x20             // =-32
    25ac: f81903a4     	stur	x4, [x29, #-0x70]
    25b0: 910003ec     	mov	x12, sp
    25b4: f81a83a7     	stur	x7, [x29, #-0x58]
    25b8: 91008129     	add	x9, x9, #0x20
    25bc: ad010fe2     	stp	q2, q3, [sp, #0x20]
    25c0: f2dff00b     	movk	x11, #0xff80, lsl #32
    25c4: ad0217e4     	stp	q4, q5, [sp, #0x40]
    25c8: 9102018c     	add	x12, x12, #0x80
    25cc: ad031fe6     	stp	q6, q7, [sp, #0x60]
    25d0: d53bd053     	mrs	x19, TPIDR_EL0
    25d4: f9401668     	ldr	x8, [x19, #0x28]
    25d8: d100a3aa     	sub	x10, x29, #0x28
    25dc: d00000a0     	adrp	x0, 0x18000 <_ZL12__insns_pool+0xc000>
    25e0: aa0303e2     	mov	x2, x3
    25e4: 91204000     	add	x0, x0, #0x810
    25e8: d10143a3     	sub	x3, x29, #0x50
    25ec: f81f83a8     	stur	x8, [x29, #-0x8]
    25f0: 910083a8     	add	x8, x29, #0x20
    25f4: a93eafac     	stp	x12, x11, [x29, #-0x18]
    25f8: 52802001     	mov	w1, #0x100              // =256
    25fc: a93da7a8     	stp	x8, x9, [x29, #-0x28]
    2600: ad400540     	ldp	q0, q1, [x10]
    2604: ad3d87a0     	stp	q0, q1, [x29, #-0x50]
    2608: 940001c6     	bl	0x2d20 <vsnprintf@plt>
    260c: f9401668     	ldr	x8, [x19, #0x28]
    2610: f85f83a9     	ldur	x9, [x29, #-0x8]
    2614: eb09011f     	cmp	x8, x9
    2618: 540000a1     	b.ne	0x262c <_ZL8snprintfPcU17pass_object_size1mPKcz+0xa0>
    261c: a9504ffc     	ldp	x28, x19, [sp, #0x100]
    2620: a94f7bfd     	ldp	x29, x30, [sp, #0xf0]
    2624: 910443ff     	add	sp, sp, #0x110
    2628: d65f03c0     	ret
    262c: 940001a5     	bl	0x2cc0 <__stack_chk_fail@plt>

0000000000002630 <find_module_callback>:
    2630: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
    2634: f9000bf5     	str	x21, [sp, #0x10]
    2638: 910003fd     	mov	x29, sp
    263c: a9024ff4     	stp	x20, x19, [sp, #0x20]
    2640: f9400415     	ldr	x21, [x0, #0x8]
    2644: b4000215     	cbz	x21, 0x2684 <find_module_callback+0x54>
    2648: aa0003f4     	mov	x20, x0
    264c: aa1503e0     	mov	x0, x21
    2650: 528005e1     	mov	w1, #0x2f               // =47
    2654: aa0203f3     	mov	x19, x2
    2658: 940001b6     	bl	0x2d30 <strrchr@plt>
    265c: f100001f     	cmp	x0, #0x0
    2660: f9400261     	ldr	x1, [x19]
    2664: 9a8006a0     	csinc	x0, x21, x0, eq
    2668: 940001b6     	bl	0x2d40 <strcmp@plt>
    266c: 34000160     	cbz	w0, 0x2698 <find_module_callback+0x68>
    2670: 2a1f03e0     	mov	w0, wzr
    2674: a9424ff4     	ldp	x20, x19, [sp, #0x20]
    2678: f9400bf5     	ldr	x21, [sp, #0x10]
    267c: a8c37bfd     	ldp	x29, x30, [sp], #0x30
    2680: d65f03c0     	ret
    2684: 2a1f03e0     	mov	w0, wzr
    2688: a9424ff4     	ldp	x20, x19, [sp, #0x20]
    268c: f9400bf5     	ldr	x21, [sp, #0x10]
    2690: a8c37bfd     	ldp	x29, x30, [sp], #0x30
    2694: d65f03c0     	ret
    2698: f9400288     	ldr	x8, [x20]
    269c: 529b1589     	mov	w9, #0xd8ac             // =55468
    26a0: 72a27a09     	movk	w9, #0x13d0, lsl #16
    26a4: 52800020     	mov	w0, #0x1                // =1
    26a8: 7940328a     	ldrh	w10, [x20, #0x18]
    26ac: 8b090109     	add	x9, x8, x9
    26b0: 39006260     	strb	w0, [x19, #0x18]
    26b4: a900a668     	stp	x8, x9, [x19, #0x8]
    26b8: b4fffdea     	cbz	x10, 0x2674 <find_module_callback+0x44>
    26bc: 9100312b     	add	x11, x9, #0xc
    26c0: f9400a8c     	ldr	x12, [x20, #0x10]
    26c4: 14000004     	b	0x26d4 <find_module_callback+0xa4>
    26c8: 9100e18c     	add	x12, x12, #0x38
    26cc: f100054a     	subs	x10, x10, #0x1
    26d0: 54000280     	b.eq	0x2720 <find_module_callback+0xf0>
    26d4: b940018d     	ldr	w13, [x12]
    26d8: 710005bf     	cmp	w13, #0x1
    26dc: 54ffff61     	b.ne	0x26c8 <find_module_callback+0x98>
    26e0: 3940118d     	ldrb	w13, [x12, #0x4]
    26e4: 3607ff2d     	tbz	w13, #0x0, 0x26c8 <find_module_callback+0x98>
    26e8: f940098d     	ldr	x13, [x12, #0x10]
    26ec: 8b0801ad     	add	x13, x13, x8
    26f0: eb0d013f     	cmp	x9, x13
    26f4: 54fffea3     	b.lo	0x26c8 <find_module_callback+0x98>
    26f8: f940158e     	ldr	x14, [x12, #0x28]
    26fc: 8b0d01cd     	add	x13, x14, x13
    2700: eb0d017f     	cmp	x11, x13
    2704: 54fffe28     	b.hi	0x26c8 <find_module_callback+0x98>
    2708: 52800020     	mov	w0, #0x1                // =1
    270c: 39006660     	strb	w0, [x19, #0x19]
    2710: a9424ff4     	ldp	x20, x19, [sp, #0x20]
    2714: f9400bf5     	ldr	x21, [sp, #0x10]
    2718: a8c37bfd     	ldp	x29, x30, [sp], #0x30
    271c: d65f03c0     	ret
    2720: 52800020     	mov	w0, #0x1                // =1
    2724: a9424ff4     	ldp	x20, x19, [sp, #0x20]
    2728: f9400bf5     	ldr	x21, [sp, #0x10]
    272c: a8c37bfd     	ldp	x29, x30, [sp], #0x30
    2730: d65f03c0     	ret

0000000000002734 <read_to_end_hook>:
    2734: a9be7bfd     	stp	x29, x30, [sp, #-0x20]!
    2738: f9000bf3     	str	x19, [sp, #0x10]
    273c: 910003fd     	mov	x29, sp
    2740: d00000a8     	adrp	x8, 0x18000 <_ZL12__insns_pool+0xc000>
    2744: f9440508     	ldr	x8, [x8, #0x808]
    2748: b4001788     	cbz	x8, 0x2a38 <read_to_end_hook+0x304>
    274c: d63f0100     	blr	x8
    2750: aa0003f3     	mov	x19, x0
    2754: b40016a0     	cbz	x0, 0x2a28 <read_to_end_hook+0x2f4>
    2758: b9401268     	ldr	w8, [x19, #0x10]
    275c: 71067d1f     	cmp	w8, #0x19f
    2760: 54001641     	b.ne	0x2a28 <read_to_end_hook+0x2f4>
    2764: 79402a68     	ldrh	w8, [x19, #0x14]
    2768: 7100f11f     	cmp	w8, #0x3c
    276c: 540015e1     	b.ne	0x2a28 <read_to_end_hook+0x2f4>
    2770: d0ffffe9     	adrp	x9, 0x0 <vsnprintf>
    2774: aa1f03eb     	mov	x11, xzr
    2778: 91041268     	add	x8, x19, #0x104
    277c: 912c8929     	add	x9, x9, #0xb22
    2780: aa0b03ea     	mov	x10, x11
    2784: f106797f     	cmp	x11, #0x19e
    2788: 54000100     	b.eq	0x27a8 <read_to_end_hook+0x74>
    278c: 8b0a066b     	add	x11, x19, x10, lsl #1
    2790: 8b0a012c     	add	x12, x9, x10
    2794: 79402d6d     	ldrh	w13, [x11, #0x16]
    2798: 9100054b     	add	x11, x10, #0x1
    279c: 3940058c     	ldrb	w12, [x12, #0x1]
    27a0: 6b0c01bf     	cmp	w13, w12
    27a4: 54fffee0     	b.eq	0x2780 <read_to_end_hook+0x4c>
    27a8: f106795f     	cmp	x10, #0x19e
    27ac: 540013e3     	b.lo	0x2a28 <read_to_end_hook+0x2f4>
    27b0: f0ffffea     	adrp	x10, 0x1000 <kCnOriginal+0x4de>
    27b4: d0ffffeb     	adrp	x11, 0x0 <vsnprintf>
    27b8: d0ffffec     	adrp	x12, 0x0 <vsnprintf>
    27bc: aa1303e9     	mov	x9, x19
    27c0: d00000a1     	adrp	x1, 0x18000 <_ZL12__insns_pool+0xc000>
    27c4: 52800020     	mov	w0, #0x1                // =1
    27c8: 3dc01940     	ldr	q0, [x10, #0x60]
    27cc: f0ffffea     	adrp	x10, 0x1000 <kCnOriginal+0x4de>
    27d0: 3dc3fd61     	ldr	q1, [x11, #0xff0]
    27d4: d0ffffeb     	adrp	x11, 0x0 <vsnprintf>
    27d8: 3dc39182     	ldr	q2, [x12, #0xe40]
    27dc: d0ffffec     	adrp	x12, 0x0 <vsnprintf>
    27e0: 3dc00543     	ldr	q3, [x10, #0x10]
    27e4: d0ffffea     	adrp	x10, 0x0 <vsnprintf>
    27e8: 3c814d20     	str	q0, [x9, #0x14]!
    27ec: 3dc3e160     	ldr	q0, [x11, #0xf80]
    27f0: ad008921     	stp	q1, q2, [x9, #0x10]
    27f4: 3dc39581     	ldr	q1, [x12, #0xe50]
    27f8: f0ffffeb     	adrp	x11, 0x1000 <kCnOriginal+0x4de>
    27fc: 3dc3cd42     	ldr	q2, [x10, #0xf30]
    2800: f0ffffea     	adrp	x10, 0x1000 <kCnOriginal+0x4de>
    2804: d0ffffec     	adrp	x12, 0x0 <vsnprintf>
    2808: ad018123     	stp	q3, q0, [x9, #0x30]
    280c: 91201021     	add	x1, x1, #0x804
    2810: ad028921     	stp	q1, q2, [x9, #0x50]
    2814: 3dc02940     	ldr	q0, [x10, #0xa0]
    2818: d0ffffea     	adrp	x10, 0x0 <vsnprintf>
    281c: 3dc00161     	ldr	q1, [x11]
    2820: f0ffffeb     	adrp	x11, 0x1000 <kCnOriginal+0x4de>
    2824: 3dc3dd82     	ldr	q2, [x12, #0xf70]
    2828: d0ffffec     	adrp	x12, 0x0 <vsnprintf>
    282c: 3dc39943     	ldr	q3, [x10, #0xe60]
    2830: ad038520     	stp	q0, q1, [x9, #0x70]
    2834: 3dc03160     	ldr	q0, [x11, #0xc0]
    2838: f0ffffea     	adrp	x10, 0x1000 <kCnOriginal+0x4de>
    283c: 3dc39d81     	ldr	q1, [x12, #0xe70]
    2840: d0ffffeb     	adrp	x11, 0x0 <vsnprintf>
    2844: d0ffffec     	adrp	x12, 0x0 <vsnprintf>
    2848: ad048d22     	stp	q2, q3, [x9, #0x90]
    284c: ad000500     	stp	q0, q1, [x8]
    2850: 3dc03540     	ldr	q0, [x10, #0xd0]
    2854: f0ffffea     	adrp	x10, 0x1000 <kCnOriginal+0x4de>
    2858: 3dc38961     	ldr	q1, [x11, #0xe20]
    285c: d0ffffeb     	adrp	x11, 0x0 <vsnprintf>
    2860: 3dc38582     	ldr	q2, [x12, #0xe10]
    2864: d0ffffec     	adrp	x12, 0x0 <vsnprintf>
    2868: 3dc03943     	ldr	q3, [x10, #0xe0]
    286c: ad010500     	stp	q0, q1, [x8, #0x20]
    2870: 3dc37d60     	ldr	q0, [x11, #0xdf0]
    2874: d0ffffea     	adrp	x10, 0x0 <vsnprintf>
    2878: 3dc3d181     	ldr	q1, [x12, #0xf40]
    287c: d0ffffeb     	adrp	x11, 0x0 <vsnprintf>
    2880: d0ffffec     	adrp	x12, 0x0 <vsnprintf>
    2884: ad020d02     	stp	q2, q3, [x8, #0x40]
    2888: ad030500     	stp	q0, q1, [x8, #0x60]
    288c: 3dc3c540     	ldr	q0, [x10, #0xf10]
    2890: d0ffffea     	adrp	x10, 0x0 <vsnprintf>
    2894: 3dc38d61     	ldr	q1, [x11, #0xe30]
    2898: d0ffffeb     	adrp	x11, 0x0 <vsnprintf>
    289c: 3dc38182     	ldr	q2, [x12, #0xe00]
    28a0: d0ffffec     	adrp	x12, 0x0 <vsnprintf>
    28a4: 3dc3ed43     	ldr	q3, [x10, #0xfb0]
    28a8: ad040500     	stp	q0, q1, [x8, #0x80]
    28ac: 3dc3e960     	ldr	q0, [x11, #0xfa0]
    28b0: d0ffffea     	adrp	x10, 0x0 <vsnprintf>
    28b4: 3dc3f981     	ldr	q1, [x12, #0xfe0]
    28b8: d0ffffeb     	adrp	x11, 0x0 <vsnprintf>
    28bc: d0ffffec     	adrp	x12, 0x0 <vsnprintf>
    28c0: ad050d02     	stp	q2, q3, [x8, #0xa0]
    28c4: ad060500     	stp	q0, q1, [x8, #0xc0]
    28c8: 3dc3f140     	ldr	q0, [x10, #0xfc0]
    28cc: d0ffffea     	adrp	x10, 0x0 <vsnprintf>
    28d0: 3dc3b961     	ldr	q1, [x11, #0xee0]
    28d4: d0ffffeb     	adrp	x11, 0x0 <vsnprintf>
    28d8: 3dc3a182     	ldr	q2, [x12, #0xe80]
    28dc: f0ffffec     	adrp	x12, 0x1000 <kCnOriginal+0x4de>
    28e0: 3dc3d943     	ldr	q3, [x10, #0xf60]
    28e4: ad070500     	stp	q0, q1, [x8, #0xe0]
    28e8: 3dc3b160     	ldr	q0, [x11, #0xec0]
    28ec: f0ffffea     	adrp	x10, 0x1000 <kCnOriginal+0x4de>
    28f0: 3dc00981     	ldr	q1, [x12, #0x20]
    28f4: d0ffffeb     	adrp	x11, 0x0 <vsnprintf>
    28f8: d0ffffec     	adrp	x12, 0x0 <vsnprintf>
    28fc: ad080d02     	stp	q2, q3, [x8, #0x100]
    2900: ad090500     	stp	q0, q1, [x8, #0x120]
    2904: 3dc01d40     	ldr	q0, [x10, #0x70]
    2908: d0ffffea     	adrp	x10, 0x0 <vsnprintf>
    290c: 3dc3a561     	ldr	q1, [x11, #0xe90]
    2910: f0ffffeb     	adrp	x11, 0x1000 <kCnOriginal+0x4de>
    2914: 3dc3f582     	ldr	q2, [x12, #0xfd0]
    2918: d0ffffec     	adrp	x12, 0x0 <vsnprintf>
    291c: 3dc3a943     	ldr	q3, [x10, #0xea0]
    2920: ad0a0500     	stp	q0, q1, [x8, #0x140]
    2924: 3dc03d60     	ldr	q0, [x11, #0xf0]
    2928: f0ffffea     	adrp	x10, 0x1000 <kCnOriginal+0x4de>
    292c: 3dc3c181     	ldr	q1, [x12, #0xf00]
    2930: f0ffffeb     	adrp	x11, 0x1000 <kCnOriginal+0x4de>
    2934: f0ffffec     	adrp	x12, 0x1000 <kCnOriginal+0x4de>
    2938: ad0b0d02     	stp	q2, q3, [x8, #0x160]
    293c: ad0c0500     	stp	q0, q1, [x8, #0x180]
    2940: 3dc04140     	ldr	q0, [x10, #0x100]
    2944: f0ffffea     	adrp	x10, 0x1000 <kCnOriginal+0x4de>
    2948: 3dc00d61     	ldr	q1, [x11, #0x30]
    294c: f0ffffeb     	adrp	x11, 0x1000 <kCnOriginal+0x4de>
    2950: 3dc02182     	ldr	q2, [x12, #0x80]
    2954: d0ffffec     	adrp	x12, 0x0 <vsnprintf>
    2958: 3dc01143     	ldr	q3, [x10, #0x40]
    295c: d0ffffea     	adrp	x10, 0x0 <vsnprintf>
    2960: ad0d0500     	stp	q0, q1, [x8, #0x1a0]
    2964: 3dc04560     	ldr	q0, [x11, #0x110]
    2968: 3dc3b581     	ldr	q1, [x12, #0xed0]
    296c: d0ffffeb     	adrp	x11, 0x0 <vsnprintf>
    2970: ad0e0d02     	stp	q2, q3, [x8, #0x1c0]
    2974: 3dc3d542     	ldr	q2, [x10, #0xf50]
    2978: f0ffffea     	adrp	x10, 0x1000 <kCnOriginal+0x4de>
    297c: d0ffffec     	adrp	x12, 0x0 <vsnprintf>
    2980: ad0f0500     	stp	q0, q1, [x8, #0x1e0]
    2984: 3dc3c963     	ldr	q3, [x11, #0xf20]
    2988: d0ffffeb     	adrp	x11, 0x0 <vsnprintf>
    298c: 3dc02540     	ldr	q0, [x10, #0x90]
    2990: d28007ca     	mov	x10, #0x3e              // =62
    2994: f2a0078a     	movk	x10, #0x3c, lsl #16
    2998: ad100d02     	stp	q2, q3, [x8, #0x200]
    299c: f2c005ea     	movk	x10, #0x2f, lsl #32
    29a0: 3dc3e581     	ldr	q1, [x12, #0xf90]
    29a4: f2e00a4a     	movk	x10, #0x52, lsl #48
    29a8: 3d808900     	str	q0, [x8, #0x220]
    29ac: 3dc3bd60     	ldr	q0, [x11, #0xef0]
    29b0: f0ffffe8     	adrp	x8, 0x1000 <kCnOriginal+0x4de>
    29b4: d0ffffeb     	adrp	x11, 0x0 <vsnprintf>
    29b8: d2800f2c     	mov	x12, #0x79              // =121
    29bc: f901912a     	str	x10, [x9, #0x320]
    29c0: d2800a6a     	mov	x10, #0x53              // =83
    29c4: f2a0082a     	movk	x10, #0x41, lsl #16
    29c8: f2a00acc     	movk	x12, #0x56, lsl #16
    29cc: f2c0096a     	movk	x10, #0x4b, lsl #32
    29d0: f2c00c2c     	movk	x12, #0x61, lsl #32
    29d4: f2e00caa     	movk	x10, #0x65, lsl #48
    29d8: ad058121     	stp	q1, q0, [x9, #0xb0]
    29dc: 3dc02d01     	ldr	q1, [x8, #0xb0]
    29e0: 52800ea8     	mov	w8, #0x75               // =117
    29e4: f2e00d8c     	movk	x12, #0x6c, lsl #48
    29e8: 3dc3ad60     	ldr	q0, [x11, #0xeb0]
    29ec: f901952a     	str	x10, [x9, #0x328]
    29f0: 72a00ca8     	movk	w8, #0x65, lsl #16
    29f4: 528007ca     	mov	w10, #0x3e              // =62
    29f8: f901992c     	str	x12, [x9, #0x330]
    29fc: ad068121     	stp	q1, q0, [x9, #0xd0]
    2a00: b9033928     	str	w8, [x9, #0x338]
    2a04: 7906792a     	strh	w10, [x9, #0x33c]
    2a08: 9400006a     	bl	0x2bb0 <__aarch64_ldadd4_relax>
    2a0c: d0ffffe1     	adrp	x1, 0x0 <vsnprintf>
    2a10: d0ffffe2     	adrp	x2, 0x0 <vsnprintf>
    2a14: 11000403     	add	w3, w0, #0x1
    2a18: 9129e021     	add	x1, x1, #0xa78
    2a1c: 912c0442     	add	x2, x2, #0xb01
    2a20: 52800080     	mov	w0, #0x4                // =4
    2a24: 9400008f     	bl	0x2c60 <__android_log_print@plt>
    2a28: aa1303e0     	mov	x0, x19
    2a2c: f9400bf3     	ldr	x19, [sp, #0x10]
    2a30: a8c27bfd     	ldp	x29, x30, [sp], #0x20
    2a34: d65f03c0     	ret
    2a38: aa1f03f3     	mov	x19, xzr
    2a3c: aa1303e0     	mov	x0, x19
    2a40: f9400bf3     	ldr	x19, [sp, #0x10]
    2a44: a8c27bfd     	ldp	x29, x30, [sp], #0x20
    2a48: d65f03c0     	ret

0000000000002a4c <__clear_cache>:
    2a4c: d503245f     	bti	c
    2a50: d00000a8     	adrp	x8, 0x18000 <_ZL12__insns_pool+0xc000>
    2a54: f9448909     	ldr	x9, [x8, #0x910]
    2a58: b4000069     	cbz	x9, 0x2a64 <__clear_cache+0x18>
    2a5c: 36e000a9     	tbz	w9, #0x1c, 0x2a70 <__clear_cache+0x24>
    2a60: 1400000f     	b	0x2a9c <__clear_cache+0x50>
    2a64: d53b0029     	mrs	x9, CTR_EL0
    2a68: f9048909     	str	x9, [x8, #0x910]
    2a6c: 37e00189     	tbnz	w9, #0x1c, 0x2a9c <__clear_cache+0x50>
    2a70: 53104d29     	ubfx	w9, w9, #16, #4
    2a74: 5280008a     	mov	w10, #0x4               // =4
    2a78: 1ac92149     	lsl	w9, w10, w9
    2a7c: cb0903ea     	neg	x10, x9
    2a80: 8a00014a     	and	x10, x10, x0
    2a84: eb01015f     	cmp	x10, x1
    2a88: 540000a2     	b.hs	0x2a9c <__clear_cache+0x50>
    2a8c: d50b7b2a     	dc	cvau, x10
    2a90: 8b09014a     	add	x10, x10, x9
    2a94: eb01015f     	cmp	x10, x1
    2a98: 54ffffa3     	b.lo	0x2a8c <__clear_cache+0x40>
    2a9c: d5033b9f     	dsb	ish
    2aa0: f9448908     	ldr	x8, [x8, #0x910]
    2aa4: 37e801a8     	tbnz	w8, #0x1d, 0x2ad8 <__clear_cache+0x8c>
    2aa8: 12000d08     	and	w8, w8, #0xf
    2aac: 52800089     	mov	w9, #0x4                // =4
    2ab0: 1ac82128     	lsl	w8, w9, w8
    2ab4: cb0803e9     	neg	x9, x8
    2ab8: 8a000129     	and	x9, x9, x0
    2abc: eb01013f     	cmp	x9, x1
    2ac0: 540000a2     	b.hs	0x2ad4 <__clear_cache+0x88>
    2ac4: d50b7529     	ic	ivau, x9
    2ac8: 8b080129     	add	x9, x9, x8
    2acc: eb01013f     	cmp	x9, x1
    2ad0: 54ffffa3     	b.lo	0x2ac4 <__clear_cache+0x78>
    2ad4: d5033b9f     	dsb	ish
    2ad8: d5033fdf     	isb
    2adc: d65f03c0     	ret

0000000000002ae0 <__aarch64_cas4_acq_rel>:
    2ae0: d503245f     	bti	c
    2ae4: d00000b0     	adrp	x16, 0x18000 <_ZL12__insns_pool+0xc000>
    2ae8: 39646210     	ldrb	w16, [x16, #0x918]
    2aec: 34000070     	cbz	w16, 0x2af8 <__aarch64_cas4_acq_rel+0x18>
    2af0: 88e0fc41     	casal	w0, w1, [x2]
    2af4: d65f03c0     	ret
    2af8: 2a0003f0     	mov	w16, w0
    2afc: 885ffc40     	ldaxr	w0, [x2]
    2b00: 6b10001f     	cmp	w0, w16
    2b04: 54000061     	b.ne	0x2b10 <__aarch64_cas4_acq_rel+0x30>
    2b08: 8811fc41     	stlxr	w17, w1, [x2]
    2b0c: 35ffff91     	cbnz	w17, 0x2afc <__aarch64_cas4_acq_rel+0x1c>
    2b10: d65f03c0     	ret

0000000000002b14 <init_have_lse_atomics>:
    2b14: d503233f     	paciasp
    2b18: d101c3ff     	sub	sp, sp, #0x70
    2b1c: a9064ffe     	stp	x30, x19, [sp, #0x60]
    2b20: 52800200     	mov	w0, #0x10               // =16
    2b24: 9400008b     	bl	0x2d50 <getauxval@plt>
    2b28: aa0003f3     	mov	x19, x0
    2b2c: 37400113     	tbnz	w19, #0x8, 0x2b4c <init_have_lse_atomics+0x38>
    2b30: 2a1f03e8     	mov	w8, wzr
    2b34: a9464ffe     	ldp	x30, x19, [sp, #0x60]
    2b38: d00000a9     	adrp	x9, 0x18000 <_ZL12__insns_pool+0xc000>
    2b3c: 39246128     	strb	w8, [x9, #0x918]
    2b40: 9101c3ff     	add	sp, sp, #0x70
    2b44: d50323bf     	autiasp
    2b48: d65f03c0     	ret
    2b4c: d0ffffe0     	adrp	x0, 0x0 <vsnprintf>
    2b50: 910013e1     	add	x1, sp, #0x4
    2b54: 91378c00     	add	x0, x0, #0xde3
    2b58: 94000082     	bl	0x2d60 <__system_property_get@plt>
    2b5c: 7100041f     	cmp	w0, #0x1
    2b60: 5400016b     	b.lt	0x2b8c <init_have_lse_atomics+0x78>
    2b64: d0ffffe1     	adrp	x1, 0x0 <vsnprintf>
    2b68: 910013e0     	add	x0, sp, #0x4
    2b6c: 912b5c21     	add	x1, x1, #0xad7
    2b70: 52800142     	mov	w2, #0xa                // =10
    2b74: 92780268     	and	x8, x19, #0x100
    2b78: d348fd13     	lsr	x19, x8, #8
    2b7c: 9400007d     	bl	0x2d70 <strncmp@plt>
    2b80: 7100001f     	cmp	w0, #0x0
    2b84: 1a9303e8     	csel	w8, wzr, w19, eq
    2b88: 14000002     	b	0x2b90 <init_have_lse_atomics+0x7c>
    2b8c: d3482268     	ubfx	x8, x19, #8, #1
    2b90: 7100011f     	cmp	w8, #0x0
    2b94: 1a9f07e8     	cset	w8, ne
    2b98: a9464ffe     	ldp	x30, x19, [sp, #0x60]
    2b9c: d00000a9     	adrp	x9, 0x18000 <_ZL12__insns_pool+0xc000>
    2ba0: 39246128     	strb	w8, [x9, #0x918]
    2ba4: 9101c3ff     	add	sp, sp, #0x70
    2ba8: d50323bf     	autiasp
    2bac: d65f03c0     	ret

0000000000002bb0 <__aarch64_ldadd4_relax>:
    2bb0: d503245f     	bti	c
    2bb4: d00000b0     	adrp	x16, 0x18000 <_ZL12__insns_pool+0xc000>
    2bb8: 39646210     	ldrb	w16, [x16, #0x918]
    2bbc: 34000070     	cbz	w16, 0x2bc8 <__aarch64_ldadd4_relax+0x18>
    2bc0: b8200020     	ldadd	w0, w0, [x1]
    2bc4: d65f03c0     	ret
    2bc8: 2a0003f0     	mov	w16, w0
    2bcc: 885f7c20     	ldxr	w0, [x1]
    2bd0: 0b100011     	add	w17, w0, w16
    2bd4: 880f7c31     	stxr	w15, w17, [x1]
    2bd8: 35ffffaf     	cbnz	w15, 0x2bcc <__aarch64_ldadd4_relax+0x1c>
    2bdc: d65f03c0     	ret

0000000000002be0 <__aarch64_ldadd4_acq_rel>:
    2be0: d503245f     	bti	c
    2be4: d00000b0     	adrp	x16, 0x18000 <_ZL12__insns_pool+0xc000>
    2be8: 39646210     	ldrb	w16, [x16, #0x918]
    2bec: 34000070     	cbz	w16, 0x2bf8 <__aarch64_ldadd4_acq_rel+0x18>
    2bf0: b8e00020     	ldaddal	w0, w0, [x1]
    2bf4: d65f03c0     	ret
    2bf8: 2a0003f0     	mov	w16, w0
    2bfc: 885ffc20     	ldaxr	w0, [x1]
    2c00: 0b100011     	add	w17, w0, w16
    2c04: 880ffc31     	stlxr	w15, w17, [x1]
    2c08: 35ffffaf     	cbnz	w15, 0x2bfc <__aarch64_ldadd4_acq_rel+0x1c>
    2c0c: d65f03c0     	ret

Disassembly of section .plt:

0000000000002c10 <.plt>:
    2c10: a9bf7bf0     	stp	x16, x30, [sp, #-0x10]!
    2c14: 90000030     	adrp	x16, 0x6000 <strncmp@plt+0x3290>
    2c18: f947da11     	ldr	x17, [x16, #0xfb0]
    2c1c: 913ec210     	add	x16, x16, #0xfb0
    2c20: d61f0220     	br	x17
    2c24: d503201f     	nop
    2c28: d503201f     	nop
    2c2c: d503201f     	nop

0000000000002c30 <__cxa_finalize@plt>:
    2c30: 90000030     	adrp	x16, 0x6000 <strncmp@plt+0x3290>
    2c34: f947de11     	ldr	x17, [x16, #0xfb8]
    2c38: 913ee210     	add	x16, x16, #0xfb8
    2c3c: d61f0220     	br	x17

0000000000002c40 <__cxa_atexit@plt>:
    2c40: 90000030     	adrp	x16, 0x6000 <strncmp@plt+0x3290>
    2c44: f947e211     	ldr	x17, [x16, #0xfc0]
    2c48: 913f0210     	add	x16, x16, #0xfc0
    2c4c: d61f0220     	br	x17

0000000000002c50 <A64HookFunctionV@plt>:
    2c50: 90000030     	adrp	x16, 0x6000 <strncmp@plt+0x3290>
    2c54: f947e611     	ldr	x17, [x16, #0xfc8]
    2c58: 913f2210     	add	x16, x16, #0xfc8
    2c5c: d61f0220     	br	x17

0000000000002c60 <__android_log_print@plt>:
    2c60: 90000030     	adrp	x16, 0x6000 <strncmp@plt+0x3290>
    2c64: f947ea11     	ldr	x17, [x16, #0xfd0]
    2c68: 913f4210     	add	x16, x16, #0xfd0
    2c6c: d61f0220     	br	x17

0000000000002c70 <mprotect@plt>:
    2c70: 90000030     	adrp	x16, 0x6000 <strncmp@plt+0x3290>
    2c74: f947ee11     	ldr	x17, [x16, #0xfd8]
    2c78: 913f6210     	add	x16, x16, #0xfd8
    2c7c: d61f0220     	br	x17

0000000000002c80 <__errno@plt>:
    2c80: 90000030     	adrp	x16, 0x6000 <strncmp@plt+0x3290>
    2c84: f947f211     	ldr	x17, [x16, #0xfe0]
    2c88: 913f8210     	add	x16, x16, #0xfe0
    2c8c: d61f0220     	br	x17

0000000000002c90 <memset@plt>:
    2c90: 90000030     	adrp	x16, 0x6000 <strncmp@plt+0x3290>
    2c94: f947f611     	ldr	x17, [x16, #0xfe8]
    2c98: 913fa210     	add	x16, x16, #0xfe8
    2c9c: d61f0220     	br	x17

0000000000002ca0 <_ZN7context15process_fix_mapEl@plt>:
    2ca0: 90000030     	adrp	x16, 0x6000 <strncmp@plt+0x3290>
    2ca4: f947fa11     	ldr	x17, [x16, #0xff0]
    2ca8: 913fc210     	add	x16, x16, #0xff0
    2cac: d61f0220     	br	x17

0000000000002cb0 <memcpy@plt>:
    2cb0: 90000030     	adrp	x16, 0x6000 <strncmp@plt+0x3290>
    2cb4: f947fe11     	ldr	x17, [x16, #0xff8]
    2cb8: 913fe210     	add	x16, x16, #0xff8
    2cbc: d61f0220     	br	x17

0000000000002cc0 <__stack_chk_fail@plt>:
    2cc0: b0000030     	adrp	x16, 0x7000 <vsnprintf+0x7000>
    2cc4: f9400211     	ldr	x17, [x16]
    2cc8: 91000210     	add	x16, x16, #0x0
    2ccc: d61f0220     	br	x17

0000000000002cd0 <A64HookFunction@plt>:
    2cd0: b0000030     	adrp	x16, 0x7000 <vsnprintf+0x7000>
    2cd4: f9400611     	ldr	x17, [x16, #0x8]
    2cd8: 91002210     	add	x16, x16, #0x8
    2cdc: d61f0220     	br	x17

0000000000002ce0 <pthread_create@plt>:
    2ce0: b0000030     	adrp	x16, 0x7000 <vsnprintf+0x7000>
    2ce4: f9400a11     	ldr	x17, [x16, #0x10]
    2ce8: 91004210     	add	x16, x16, #0x10
    2cec: d61f0220     	br	x17

0000000000002cf0 <pthread_detach@plt>:
    2cf0: b0000030     	adrp	x16, 0x7000 <vsnprintf+0x7000>
    2cf4: f9400e11     	ldr	x17, [x16, #0x18]
    2cf8: 91006210     	add	x16, x16, #0x18
    2cfc: d61f0220     	br	x17

0000000000002d00 <nanosleep@plt>:
    2d00: b0000030     	adrp	x16, 0x7000 <vsnprintf+0x7000>
    2d04: f9401211     	ldr	x17, [x16, #0x20]
    2d08: 91008210     	add	x16, x16, #0x20
    2d0c: d61f0220     	br	x17

0000000000002d10 <dl_iterate_phdr@plt>:
    2d10: b0000030     	adrp	x16, 0x7000 <vsnprintf+0x7000>
    2d14: f9401611     	ldr	x17, [x16, #0x28]
    2d18: 9100a210     	add	x16, x16, #0x28
    2d1c: d61f0220     	br	x17

0000000000002d20 <vsnprintf@plt>:
    2d20: b0000030     	adrp	x16, 0x7000 <vsnprintf+0x7000>
    2d24: f9401a11     	ldr	x17, [x16, #0x30]
    2d28: 9100c210     	add	x16, x16, #0x30
    2d2c: d61f0220     	br	x17

0000000000002d30 <strrchr@plt>:
    2d30: b0000030     	adrp	x16, 0x7000 <vsnprintf+0x7000>
    2d34: f9401e11     	ldr	x17, [x16, #0x38]
    2d38: 9100e210     	add	x16, x16, #0x38
    2d3c: d61f0220     	br	x17

0000000000002d40 <strcmp@plt>:
    2d40: b0000030     	adrp	x16, 0x7000 <vsnprintf+0x7000>
    2d44: f9402211     	ldr	x17, [x16, #0x40]
    2d48: 91010210     	add	x16, x16, #0x40
    2d4c: d61f0220     	br	x17

0000000000002d50 <getauxval@plt>:
    2d50: b0000030     	adrp	x16, 0x7000 <vsnprintf+0x7000>
    2d54: f9402611     	ldr	x17, [x16, #0x48]
    2d58: 91012210     	add	x16, x16, #0x48
    2d5c: d61f0220     	br	x17

0000000000002d60 <__system_property_get@plt>:
    2d60: b0000030     	adrp	x16, 0x7000 <vsnprintf+0x7000>
    2d64: f9402a11     	ldr	x17, [x16, #0x50]
    2d68: 91014210     	add	x16, x16, #0x50
    2d6c: d61f0220     	br	x17

0000000000002d70 <strncmp@plt>:
    2d70: b0000030     	adrp	x16, 0x7000 <vsnprintf+0x7000>
    2d74: f9402e11     	ldr	x17, [x16, #0x58]
    2d78: 91016210     	add	x16, x16, #0x58
    2d7c: d61f0220     	br	x17
