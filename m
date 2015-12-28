Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-db3on0085.outbound.protection.outlook.com ([157.55.234.85]:65138
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752566AbbL1XSG convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 28 Dec 2015 18:18:06 -0500
From: Thierry BERTAUD <tbertaud@conforama.fr>
Subject: RE: fio-f1480f9: AIX 6.1 build KO against gcc function overlap
Date: Mon, 28 Dec 2015 23:18:01 +0000
Message-ID: <VI1PR05MB1343114D6BA9A17FE10196BFB1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
References: <VI1PR05MB1343197BD54DC24EA6A2AF65B1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>,<CANvN+e=Vdo=zO5jcJQU8FLiiKBRZTun=9XTRixv8VNnoJm7K=w@mail.gmail.com>
In-Reply-To: <CANvN+e=Vdo=zO5jcJQU8FLiiKBRZTun=9XTRixv8VNnoJm7K=w@mail.gmail.com>
Content-Language: fr-FR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Andrey,

Thanks for your feedback but i don't succeed with the build.

Concerning this point:
>> lib/pattern.c: In function 'parse_number':
>> lib/pattern.c:77:3: warning: implicit declaration of function 'strcasestr' [-Wimplicit-function-declaration]
>>    _end = strcasestr(beg, "0x");
>>    ^
>> lib/pattern.c:77:8: warning: assignment makes pointer from integer without a cast [enabled by default]
>>    _end = strcasestr(beg, "0x");
>
> It looks like AIX defines the strcasetr outside the <string.h>, so you
> might want to add AIX-specific include.

It seems from https://www.gnu.org/software/gnulib/manual/html_node/strcasestr.html, i can ignore it because  tried option to set LIBPATH to include libreary for AIX have no effect (LIBPATH=/lib:/usr/lib gmake CC=gcc)

For fio_send_file:
> Seems to be AIX sys/socket.h specific, you can just rename the above
> to fio_send_file, I believe.
I renamed it and try again but i have the following issue because AIX not include getpot.h. 
AIX provides the getopt definition s in 'unistd.h'.
# grep -i getopt /usr/include/unistd.h
        extern  int     getopt();
        extern  int     getopt(int, char* const*, const char*);
#

But from source i have unistd.h always included:
"#include <stdint.h>
#include <unistd.h>
#include <string.h>

#include "getopt.h"
"

-------
    CC oslib/getopt_long.o
oslib/getopt_long.c:17:20: fatal error: getopt.h: No such file or directory
 #include "getopt.h"
                    ^
compilation terminated.
Makefile:289: recipe for target 'oslib/getopt_long.o' failed
gmake: *** [oslib/getopt_long.o] Error 1
------

Below the full ouput:
# LIBPATH=/lib:/usr/lib gmake CC=gcc
FIO_VERSION = fio-2.3
    CC crc/crc64.o
    CC crc/md5.o
    CC crc/fnv.o
    CC crc/sha256.o
    CC crc/test.o
    CC crc/xxhash.o
    CC crc/crc32c-intel.o
    CC crc/murmur3.o
    CC crc/crc32.o
    CC crc/crc32c.o
    CC crc/sha1.o
    CC crc/crc7.o
    CC crc/sha512.o
    CC crc/crc16.o
    CC lib/gauss.o
    CC lib/prio_tree.o
    CC lib/axmap.o
    CC lib/flist_sort.o
    CC lib/hweight.o
    CC lib/zipf.o
    CC lib/getrusage.o
    CC lib/output_buffer.o
    CC lib/memalign.o
    CC lib/lfsr.o
    CC lib/bloom.o
    CC lib/strntol.o
    CC lib/num2str.o
    CC lib/mountcheck.o
    CC lib/pattern.o
lib/pattern.c: In function 'parse_number':
lib/pattern.c:77:3: warning: implicit declaration of function 'strcasestr' [-Wimplicit-function-declaration]
   _end = strcasestr(beg, "0x");
   ^
lib/pattern.c:77:8: warning: assignment makes pointer from integer without a cast [enabled by default]
   _end = strcasestr(beg, "0x");
        ^
    CC lib/ieee754.o
    CC lib/rbtree.o
    CC lib/rand.o
    CC gettime.o
    CC ioengines.o
    CC init.o
    CC stat.o
    CC log.o
    CC time.o
    CC filesetup.o
    CC eta.o
    CC verify.o
    CC memory.o
    CC io_u.o
    CC parse.o
    CC mutex.o
    CC options.o
    CC smalloc.o
    CC filehash.o
    CC profile.o
    CC debug.o
    CC engines/cpu.o
    CC engines/mmap.o
    CC engines/sync.o
    CC engines/null.o
    CC engines/net.o
    CC server.o
    CC client.o
client.c: In function 'fio_handle_client':
client.c:1639:3: warning: passing argument 1 of 'send_file' from incompatible pointer type [enabled by default]
   send_file(client, pdu, cmd->tag);
   ^
In file included from client.c:11:0:
/usr/include/sys/socket.h:760:9: note: expected 'int *' but argument is of type 'struct fio_client *'
 ssize_t send_file(int *, struct sf_parms *, uint_t);
         ^
client.c:1639:3: warning: passing argument 2 of 'send_file' from incompatible pointer type [enabled by default]
   send_file(client, pdu, cmd->tag);
   ^
In file included from client.c:11:0:
/usr/include/sys/socket.h:760:9: note: expected 'struct sf_parms *' but argument is of type 'struct cmd_sendfile *'
 ssize_t send_file(int *, struct sf_parms *, uint_t);
         ^
client.c: At top level:
client.c:1488:12: warning: 'fio_send_file' defined but not used [-Wunused-function]
 static int fio_send_file(struct fio_client *client, struct cmd_sendfile *pdu,
            ^
    CC iolog.o
    CC backend.o
    CC libfio.o
    CC flow.o
    CC cconv.o
    CC gettime-thread.o
    CC helpers.o
    CC json.o
    CC idletime.o
    CC td_error.o
    CC profiles/tiobench.o
    CC profiles/act.o
    CC io_u_queue.o
    CC filelock.o
    CC workqueue.o
    CC rate-submit.o
    CC engines/posixaio.o
    CC oslib/strcasestr.o
    CC oslib/strlcat.o
    CC oslib/getopt_long.o
oslib/getopt_long.c:17:20: fatal error: getopt.h: No such file or directory
 #include "getopt.h"
                    ^
compilation terminated.
Makefile:289: recipe for target 'oslib/getopt_long.o' failed
gmake: *** [oslib/getopt_long.o] Error 1
#

Regards,
Thierry
