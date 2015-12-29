Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-db3on0088.outbound.protection.outlook.com ([157.55.234.88]:57287
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752690AbbL2Oow convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 29 Dec 2015 09:44:52 -0500
From: Thierry BERTAUD <tbertaud@conforama.fr>
Subject: RE: fio-2c2c93d and with a lot of numjobs causing fio Jobs to Time
 Out
Date: Tue, 29 Dec 2015 14:30:02 +0000
Message-ID: <VI1PR05MB1343ACF281E36FF71F7F577CB1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
References: <VI1PR05MB13437814C9CD31D2CECE7398B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
In-Reply-To: <VI1PR05MB13437814C9CD31D2CECE7398B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
Content-Language: fr-FR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hello Fio team,

Just some information.
Fio is always stuck several hours later. It takes a lot of cpu (62 % of the server) but do nothing concerning IO against hdisk and hba card.

If you need more information don't hesitate to ask.

Below output from topas and gdb:
Topas:
--------------------------------------------
Topas Monitor for host:    XVIOS16              
Tue Dec 29 15:00:31 2015   Interval:  2         
                                                
CPU  User%  Kern%  Wait%  Idle%  Physc   Entc   
ALL   60.1    3.0    0.0   36.8   1.01  101.3   
                                                
Network  KBPS   I-Pack  O-Pack   KB-In  KB-Out  
Total     3.6     63.0     2.5     3.3     0.2  
                                                
EVENTS/QUEUES    FILE/TTY
Cswitch     722         Readch     2386                                                
Syscall   22916         Writech     386                                                
Reads        10            Rawin         0                                                
Writes        3             Ttyout      272                                                
Forks         0              Igets         0                                                
Execs         0              Namei       212                                                
Runqueue    1.0       Dirblk        0                                                
Waitqueue   0.0                                                

                  MEMORY
 PAGING                Real,MB   16384
 Faults       40        % Comp     18 
 Steals        0         % Noncomp  50                                                
 PgspIn        0        % Client   50                                                
 PgspOut       0                                                
 PageIn        0        PAGING SPACE                                                
 PageOut       0     Size,MB     512                                                
 Sios          0          % Used      4                                                
                              % Free     96                                                
                                                

Disk    Busy%     KBPS     TPS KB-Read KB-Writ 
hdisk3    0.0     0.0      0.0    0.0     0.0  
hdisk2    0.0     0.0      0.0    0.0     0.0  
hdisk4    0.0     0.0      0.0    0.0     0.0  
hdisk1    0.0     0.0      0.0    0.0     0.0  
hdisk0    0.0     0.0      0.0    0.0     0.0  
hdisk6    0.0     0.0      0.0    0.0     0.0  
hdisk9    0.0     0.0      0.0    0.0     0.0  
hdisk10   0.0     0.0      0.0    0.0     0.0  
hdisk5    0.0     0.0      0.0    0.0     0.0  
hdisk7    0.0     0.0      0.0    0.0     0.0   
                                                
NFS (calls/sec)
SerV2         0  WPAR Activ     0                                                
CliV2         0  WPAR Total     0                                                
SerV3         0  Press: "h"-help                                                
CliV3         0         "q"-quit                                                
SerV4         0                                                
CliV4         0                                                
                                                
                                                
FileSystem        KBPS     TPS KB-Read KB-Writ  
Total              2.3     9.5    2.3    0.0    
                                                
Name            PID  CPU%  PgSp Owner           
fio        11468956  62.6   4.3 root            
sched        196614   0.0   0.4 root
vio_daem   10682558   0.0  46.1 root
seaproc     3997822   0.0   1.0 root
java        9764964   0.0  84.1 root
syncd       3538998   0.0   0.6 root
getty       9830486   0.0   0.7 root
sshd        9306218   0.0   1.2 padmin
solid       7995450   0.0  40.0 root
gil         2555982   0.0   0.9 root
posix_ai   53411958   0.0   0.4 root
posix_ai   19529906   0.0   0.4 root
posix_ai   58982424   0.0   0.4 root
fio         3015098   0.0   2.7 root
posix_ai   64946350   0.0   0.4 root
posix_ai   39976972   0.0   0.4 root
topas       1180092   0.0   8.7 root
posix_ai   57737462   0.0   0.4 root
posix_ai   27787362   0.0   0.4 root
posix_ai   44302422   0.0   0.4 root

gdb output:
-----------------------------
# ps -ef | grep fio
    root 11468956 39518300 120 02:47:26  pts/1 468:59 /home/padmin/fio/fio-2c2c93d/fio myfio.fio
    root 44105746 11206870   0 15:23:58  pts/0  0:00 grep fio
    root  3015098 11141224   0 03:24:48  pts/0  0:28 fio myfio.fio
# gdb /home/padmin/fio/fio-2c2c93d/fio 3015098
GNU gdb (GDB) 7.8.1
Copyright (C) 2014 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "powerpc-ibm-aix5.1.0.0".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from /home/padmin/fio/fio-2c2c93d/fio...done.
Attaching to program: /home/padmin/fio/fio-2c2c93d/fio, process 3015098
[New Thread 1]
[New Thread 258]
[Switching to Thread 258]
0xd051d470 in _p_nsleep () from /usr/lib/libpthread.a(shr_xpg5.o)
(gdb) bt
#0  0xd051d470 in _p_nsleep () from /usr/lib/libpthread.a(shr_xpg5.o)
#1  0xd011f3e8 in nsleep () from /usr/lib/libc.a(shr.o)
#2  0xd011ee38 in usleep () from /usr/lib/libc.a(shr.o)
#3  0x10001110 in fio_set_fd_nonblocking (fd=805309560, who=0x0) at libfio.c:285
#4  0xd0505c10 in _pthread_body () from /usr/lib/libpthread.a(shr_xpg5.o)
#5  0x00000000 in ?? ()
(gdb) 


Regards,
Thierry