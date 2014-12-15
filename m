Return-Path: <Elliott@hp.com>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: fio main thread got stuck over the weekend
Date: Mon, 15 Dec 2014 17:33:28 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295940EEC5@G4W3202.americas.hpqcorp.net>
References: <20140811154423.GE7486@beardog.cce.hp.com>
 <20140811160418.GG7486@beardog.cce.hp.com> <53F79442.6010500@kernel.dk>
 <20140822190924.GQ19666@beardog.cce.hp.com> <53F795E0.3090806@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B40295940B8A0@G4W3202.americas.hpqcorp.net>
 <548BC55F.9020706@kernel.dk>
In-Reply-To: <548BC55F.9020706@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "stephenmcameron@gmail.com" <stephenmcameron@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

>=20
> If you have it running, it would be great to do a gdb attach and see
> what the frontend is up to (or where it might be stuck)...
>=20

The last eta printed over 3 days ago was
	[eta 01d:17h:05m:24s]
but it is still running.

One device did report several errors during the test before the eta=20
hang, and there are no IOs going to that device.

There are 212 threads running out of 224 started.

(gdb) info threads
  212 Thread 0x7fa9a086e700 (LWP 6509)  0x0000003974c0b98e in pthread_cond_=
timedwait@@GLIBC_2.3.2 () from /lib64/libpthread.so.0
  211 Thread 0x7fa9a006b700 (LWP 6510)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  210 Thread 0x7fa99f869700 (LWP 6511)  0x0000003657600614 in ?? () from /l=
ib64/libaio.so.1
  209 Thread 0x7fa99f067700 (LWP 6512)  last_block (td=3D0x7fa9a094e740, f=
=3D0x7fa9a91a8390, ddir=3D<value optimized out>, b=3D0x7fa99f066c50) at io_=
u.c:65
  208 Thread 0x7fa99e865700 (LWP 6513)  0x0000003657600614 in ?? () from /l=
ib64/libaio.so.1
  207 Thread 0x7fa99e063700 (LWP 6514)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  206 Thread 0x7fa99d861700 (LWP 6515)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  205 Thread 0x7fa99d05f700 (LWP 6516)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  204 Thread 0x7fa99c85d700 (LWP 6517)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  203 Thread 0x7fa99c05b700 (LWP 6518)  0x0000003657600614 in ?? () from /l=
ib64/libaio.so.1
  202 Thread 0x7fa99b859700 (LWP 6519)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  201 Thread 0x7fa99b057700 (LWP 6520)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  200 Thread 0x7fa99a855700 (LWP 6521)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  199 Thread 0x7fa99a053700 (LWP 6522)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  198 Thread 0x7fa999851700 (LWP 6523)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  197 Thread 0x7fa99904e700 (LWP 6524)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  196 Thread 0x7fa99884c700 (LWP 6525)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  195 Thread 0x7fa99804a700 (LWP 6526)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  194 Thread 0x7fa997848700 (LWP 6527)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  193 Thread 0x7fa997046700 (LWP 6528)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  192 Thread 0x7fa996844700 (LWP 6529)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  191 Thread 0x7fa996042700 (LWP 6530)  0x0000003657600614 in ?? () from /l=
ib64/libaio.so.1
  190 Thread 0x7fa995840700 (LWP 6531)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  189 Thread 0x7fa99503e700 (LWP 6532)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  188 Thread 0x7fa99483c700 (LWP 6533)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  187 Thread 0x7fa99403a700 (LWP 6534)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  186 Thread 0x7fa993838700 (LWP 6535)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  185 Thread 0x7fa993036700 (LWP 6536)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  184 Thread 0x7fa992834700 (LWP 6537)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  183 Thread 0x7fa992031700 (LWP 6538)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  182 Thread 0x7fa99182f700 (LWP 6539)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  181 Thread 0x7fa99102d700 (LWP 6540)  0x0000003657600614 in ?? () from /l=
ib64/libaio.so.1
  180 Thread 0x7fa99082b700 (LWP 6541)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  179 Thread 0x7fa990029700 (LWP 6542)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  178 Thread 0x7fa98f827700 (LWP 6543)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  177 Thread 0x7fa98f025700 (LWP 6544)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  176 Thread 0x7fa98e823700 (LWP 6545)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  175 Thread 0x7fa98e021700 (LWP 6546)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  174 Thread 0x7fa98d81f700 (LWP 6547)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  173 Thread 0x7fa98d01d700 (LWP 6548)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  172 Thread 0x7fa98c81b700 (LWP 6549)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  171 Thread 0x7fa98c019700 (LWP 6550)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  170 Thread 0x7fa98b817700 (LWP 6551)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  169 Thread 0x7fa98b014700 (LWP 6552)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  168 Thread 0x7fa98a812700 (LWP 6553)  0x0000003657600614 in ?? () from /l=
ib64/libaio.so.1
  167 Thread 0x7fa98a010700 (LWP 6554)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  166 Thread 0x7fa98980e700 (LWP 6555)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  165 Thread 0x7fa98900c700 (LWP 6556)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  164 Thread 0x7fa98880a700 (LWP 6557)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  163 Thread 0x7fa988008700 (LWP 6558)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  162 Thread 0x7fa987806700 (LWP 6559)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  161 Thread 0x7fa987004700 (LWP 6560)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  160 Thread 0x7fa986802700 (LWP 6561)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  159 Thread 0x7fa986000700 (LWP 6562)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  158 Thread 0x7fa9857fe700 (LWP 6563)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  157 Thread 0x7fa984ffc700 (LWP 6564)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  156 Thread 0x7fa9847fa700 (LWP 6565)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  155 Thread 0x7fa983ff7700 (LWP 6566)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  154 Thread 0x7fa9837f5700 (LWP 6567)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  153 Thread 0x7fa982ff3700 (LWP 6568)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  152 Thread 0x7fa9827f1700 (LWP 6569)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  151 Thread 0x7fa981fef700 (LWP 6570)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  150 Thread 0x7fa9817ed700 (LWP 6571)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  149 Thread 0x7fa980feb700 (LWP 6572)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  148 Thread 0x7fa9807e9700 (LWP 6573)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  147 Thread 0x7fa97ffe7700 (LWP 6574)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  146 Thread 0x7fa97f7e5700 (LWP 6575)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  145 Thread 0x7fa97efe3700 (LWP 6576)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  144 Thread 0x7fa97e7e1700 (LWP 6577)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  143 Thread 0x7fa97dfdf700 (LWP 6578)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  142 Thread 0x7fa97d7dd700 (LWP 6579)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  141 Thread 0x7fa97cfda700 (LWP 6580)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  140 Thread 0x7fa97c7d8700 (LWP 6581)  0x0000003657600614 in ?? () from /l=
ib64/libaio.so.1
  139 Thread 0x7fa97bfd6700 (LWP 6582)  0x0000003657600614 in ?? () from /l=
ib64/libaio.so.1
  138 Thread 0x7fa97b7d4700 (LWP 6583)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  137 Thread 0x7fa97afd2700 (LWP 6584)  0x0000003657600614 in ?? () from /l=
ib64/libaio.so.1
  136 Thread 0x7fa97a7d0700 (LWP 6585)  0x0000003657600614 in ?? () from /l=
ib64/libaio.so.1
  135 Thread 0x7fa979fce700 (LWP 6586)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  134 Thread 0x7fa9797cc700 (LWP 6587)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  133 Thread 0x7fa978fca700 (LWP 6588)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  132 Thread 0x7fa9787c8700 (LWP 6589)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  131 Thread 0x7fa977fc6700 (LWP 6590)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  130 Thread 0x7fa9777c4700 (LWP 6591)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  129 Thread 0x7fa976fc2700 (LWP 6592)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  128 Thread 0x7fa9767c0700 (LWP 6593)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  127 Thread 0x7fa975fbd700 (LWP 6594)  0x0000003657600614 in ?? () from /l=
ib64/libaio.so.1
  126 Thread 0x7fa9757bb700 (LWP 6595)  0x0000003657600614 in ?? () from /l=
ib64/libaio.so.1
  125 Thread 0x7fa974fb9700 (LWP 6596)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  124 Thread 0x7fa9747b7700 (LWP 6597)  0x0000003657600614 in ?? () from /l=
ib64/libaio.so.1
  123 Thread 0x7fa973fb5700 (LWP 6598)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  122 Thread 0x7fa9737b3700 (LWP 6599)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  121 Thread 0x7fa972fb1700 (LWP 6600)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  120 Thread 0x7fa9727af700 (LWP 6601)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  119 Thread 0x7fa971fad700 (LWP 6602)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  118 Thread 0x7fa9717ab700 (LWP 6603)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  117 Thread 0x7fa970fa9700 (LWP 6604)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  116 Thread 0x7fa9707a7700 (LWP 6605)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  115 Thread 0x7fa96ffa5700 (LWP 6606)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  114 Thread 0x7fa96f7a3700 (LWP 6607)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  113 Thread 0x7fa9637f6700 (LWP 6622)  0x0000003657600614 in ?? () from /l=
ib64/libaio.so.1
  112 Thread 0x7fa962ff5700 (LWP 6623)  0x0000003657600614 in ?? () from /l=
ib64/libaio.so.1
  111 Thread 0x7fa9627f4700 (LWP 6624)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  110 Thread 0x7fa961ff3700 (LWP 6625)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  109 Thread 0x7fa9617f2700 (LWP 6626)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  108 Thread 0x7fa960ff1700 (LWP 6627)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  107 Thread 0x7fa9607f0700 (LWP 6628)  0x0000003657600614 in ?? () from /l=
ib64/libaio.so.1
  106 Thread 0x7fa95ffef700 (LWP 6629)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  105 Thread 0x7fa95f7ee700 (LWP 6630)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  104 Thread 0x7fa95efed700 (LWP 6631)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  103 Thread 0x7fa95e7ec700 (LWP 6632)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  102 Thread 0x7fa95dfeb700 (LWP 6633)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  101 Thread 0x7fa95d7ea700 (LWP 6634)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  100 Thread 0x7fa95cfe9700 (LWP 6635)  0x0000003657600667 in io_submit () =
from /lib64/libaio.so.1
  99 Thread 0x7fa95c7e8700 (LWP 6636)  0x0000003657600614 in ?? () from /li=
b64/libaio.so.1
  98 Thread 0x7fa95bfe7700 (LWP 6637)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  97 Thread 0x7fa95b7e6700 (LWP 6638)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  96 Thread 0x7fa95afe5700 (LWP 6639)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  95 Thread 0x7fa95a7e4700 (LWP 6640)  0x0000003657600614 in ?? () from /li=
b64/libaio.so.1
  94 Thread 0x7fa959fe3700 (LWP 6641)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  93 Thread 0x7fa9597e2700 (LWP 6642)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  92 Thread 0x7fa958fe1700 (LWP 6643)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  91 Thread 0x7fa9587e0700 (LWP 6644)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  90 Thread 0x7fa957fdf700 (LWP 6645)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  89 Thread 0x7fa9577de700 (LWP 6646)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  88 Thread 0x7fa956fdd700 (LWP 6647)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  87 Thread 0x7fa9567dc700 (LWP 6648)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  86 Thread 0x7fa955fdb700 (LWP 6649)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  85 Thread 0x7fa9557da700 (LWP 6650)  0x0000003657600614 in ?? () from /li=
b64/libaio.so.1
  84 Thread 0x7fa954fd9700 (LWP 6651)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  83 Thread 0x7fa9547d8700 (LWP 6652)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  82 Thread 0x7fa953fd7700 (LWP 6653)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  81 Thread 0x7fa9537d6700 (LWP 6654)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  80 Thread 0x7fa952fd5700 (LWP 6655)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  79 Thread 0x7fa9527d4700 (LWP 6656)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  78 Thread 0x7fa951fd3700 (LWP 6657)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  77 Thread 0x7fa9517d2700 (LWP 6658)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  76 Thread 0x7fa950fd1700 (LWP 6659)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  75 Thread 0x7fa9507d0700 (LWP 6660)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  74 Thread 0x7fa94ffcf700 (LWP 6661)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  73 Thread 0x7fa94f7ce700 (LWP 6662)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  72 Thread 0x7fa94efcd700 (LWP 6663)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  71 Thread 0x7fa94e7cc700 (LWP 6664)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  70 Thread 0x7fa94dfcb700 (LWP 6665)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  69 Thread 0x7fa94d7ca700 (LWP 6666)  0x0000003657600614 in ?? () from /li=
b64/libaio.so.1
  68 Thread 0x7fa94cfc9700 (LWP 6667)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  67 Thread 0x7fa94c7c8700 (LWP 6668)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  66 Thread 0x7fa94bfc7700 (LWP 6669)  0x0000003657600614 in ?? () from /li=
b64/libaio.so.1
  65 Thread 0x7fa94b7c6700 (LWP 6670)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  64 Thread 0x7fa94afc5700 (LWP 6671)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  63 Thread 0x7fa94a7c4700 (LWP 6672)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  62 Thread 0x7fa949fc3700 (LWP 6673)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  61 Thread 0x7fa9497c2700 (LWP 6674)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  60 Thread 0x7fa948fc1700 (LWP 6675)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  59 Thread 0x7fa9487c0700 (LWP 6676)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  58 Thread 0x7fa947fbf700 (LWP 6677)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  57 Thread 0x7fa9477be700 (LWP 6678)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  56 Thread 0x7fa946fbd700 (LWP 6679)  0x0000003657600614 in ?? () from /li=
b64/libaio.so.1
  55 Thread 0x7fa9467bc700 (LWP 6680)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  54 Thread 0x7fa945fbb700 (LWP 6681)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  53 Thread 0x7fa9457ba700 (LWP 6682)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  52 Thread 0x7fa944fb9700 (LWP 6683)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  51 Thread 0x7fa9447b8700 (LWP 6684)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  50 Thread 0x7fa943fb7700 (LWP 6685)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  49 Thread 0x7fa9437b6700 (LWP 6686)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  48 Thread 0x7fa942fb5700 (LWP 6687)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  47 Thread 0x7fa9427b4700 (LWP 6688)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  46 Thread 0x7fa941fb3700 (LWP 6689)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  45 Thread 0x7fa9417b2700 (LWP 6690)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  44 Thread 0x7fa940fb1700 (LWP 6691)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  43 Thread 0x7fa9407b0700 (LWP 6692)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  42 Thread 0x7fa93ffaf700 (LWP 6693)  0x0000003657600614 in ?? () from /li=
b64/libaio.so.1
  41 Thread 0x7fa93f7ae700 (LWP 6694)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  40 Thread 0x7fa93efad700 (LWP 6695)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  39 Thread 0x7fa93e7ac700 (LWP 6696)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  38 Thread 0x7fa93dfab700 (LWP 6697)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  37 Thread 0x7fa93d7aa700 (LWP 6698)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  36 Thread 0x7fa93cfa9700 (LWP 6699)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  35 Thread 0x7fa93c7a8700 (LWP 6700)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  34 Thread 0x7fa93bfa7700 (LWP 6701)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  33 Thread 0x7fa93b7a6700 (LWP 6702)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  32 Thread 0x7fa93afa5700 (LWP 6703)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  31 Thread 0x7fa93a7a4700 (LWP 6704)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  30 Thread 0x7fa939fa3700 (LWP 6705)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  29 Thread 0x7fa9397a2700 (LWP 6706)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  28 Thread 0x7fa938fa1700 (LWP 6707)  0x0000003657600614 in ?? () from /li=
b64/libaio.so.1
  27 Thread 0x7fa9387a0700 (LWP 6708)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  26 Thread 0x7fa937f9f700 (LWP 6709)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  25 Thread 0x7fa93779e700 (LWP 6710)  0x0000003657600614 in ?? () from /li=
b64/libaio.so.1
  24 Thread 0x7fa936f9d700 (LWP 6711)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  23 Thread 0x7fa93679c700 (LWP 6712)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  22 Thread 0x7fa935f9b700 (LWP 6713)  0x0000003657600614 in ?? () from /li=
b64/libaio.so.1
  21 Thread 0x7fa93579a700 (LWP 6714)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  20 Thread 0x7fa934f99700 (LWP 6715)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  19 Thread 0x7fa934798700 (LWP 6716)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  18 Thread 0x7fa933f97700 (LWP 6717)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  17 Thread 0x7fa933796700 (LWP 6718)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  16 Thread 0x7fa932f95700 (LWP 6719)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  15 Thread 0x7fa932794700 (LWP 6720)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  14 Thread 0x7fa931f93700 (LWP 6721)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  13 Thread 0x7fa931792700 (LWP 6722)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  12 Thread 0x7fa930f91700 (LWP 6723)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  11 Thread 0x7fa930790700 (LWP 6724)  0x000000000040b466 in td_io_getevent=
s (td=3D0x7fa9a0da27c0, min=3D14, max=3D14, t=3D0x0) at ioengines.c:237
  10 Thread 0x7fa92ff8f700 (LWP 6725)  0x0000003657600667 in io_submit () f=
rom /lib64/libaio.so.1
  9 Thread 0x7fa92f78e700 (LWP 6726)  0x0000003657600667 in io_submit () fr=
om /lib64/libaio.so.1
  8 Thread 0x7fa92ef8d700 (LWP 6727)  0x0000003657600667 in io_submit () fr=
om /lib64/libaio.so.1
  7 Thread 0x7fa92e78c700 (LWP 6728)  0x0000003657600667 in io_submit () fr=
om /lib64/libaio.so.1
  6 Thread 0x7fa92df8b700 (LWP 6729)  0x0000003657600614 in ?? () from /lib=
64/libaio.so.1
  5 Thread 0x7fa92d78a700 (LWP 6730)  0x0000003657600667 in io_submit () fr=
om /lib64/libaio.so.1
  4 Thread 0x7fa92cf89700 (LWP 6731)  0x0000003657600667 in io_submit () fr=
om /lib64/libaio.so.1
  3 Thread 0x7fa92c788700 (LWP 6732)  0x0000003657600667 in io_submit () fr=
om /lib64/libaio.so.1
  2 Thread 0x7fa92bf87700 (LWP 6733)  0x0000003657600667 in io_submit () fr=
om /lib64/libaio.so.1
* 1 Thread 0x7fa9a99b1720 (LWP 6508)  0x00000039748acced in nanosleep () fr=
om /lib64/libc.so.6

I wonder if one of the time values is wrong or overflowing.  There was a pr=
oblem in
handling ms vs. s units a while back...

(gdb) thread 2
[Switching to thread 2 (Thread 0x7fa92bf87700 (LWP 6733))]#0  0x00000036576=
00667 in io_submit () from /lib64/libaio.so.1
(gdb) bt
#0  0x0000003657600667 in io_submit () from /lib64/libaio.so.1
#1  0x0000000000457058 in fio_libaio_commit (td=3D0x7fa9a0dd1860) at engine=
s/libaio.c:255
#2  0x000000000040b395 in td_io_commit (td=3D0x7fa9a0dd1860) at ioengines.c=
:396
#3  0x000000000040bea1 in td_io_queue (td=3D0x7fa9a0dd1860, io_u=3D0x7fa8e4=
015400) at ioengines.c:343
#4  0x000000000044a75d in do_io (td=3D0x7fa9a0dd1860) at backend.c:792
#5  0x000000000044c209 in thread_main (data=3D0x7fa9a0dd1860) at backend.c:=
1504
#6  0x0000003974c079d1 in start_thread () from /lib64/libpthread.so.0
#7  0x00000039748e8b7d in clone () from /lib64/libc.so.6
(gdb) select-frame 5
(gdb) print elapsed
$29 =3D <value optimized out>
(gdb) print td->ts.runtime
$30 =3D {68075502, 0, 0}
(gdb) print td->start
$31 =3D {tv_sec =3D 1099511, tv_usec =3D 861468}
(gdb) print td->epoch
$32 =3D {tv_sec =3D 1031436, tv_usec =3D 430008}
(gdb) print td->ts.total_run_time
$33 =3D 0
(gdb) print td->ts.runtime
$35 =3D {68075502, 0, 0}

68075502 ms is only 18.9 minutes.




