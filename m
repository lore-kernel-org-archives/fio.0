Return-Path: <jeremic@informatik.uni-rostock.de>
Message-ID: <51224D3E.6020805@informatik.uni-rostock.de>
Date: Mon, 18 Feb 2013 16:48:14 +0100
From: Nikolaus Jeremic <jeremic@informatik.uni-rostock.de>
MIME-Version: 1.0
Subject: Re: All I/O patterns are replayed to one file with fio 2.0.13
References: <511D3CDE.6070302@informatik.uni-rostock.de> <20130218135756.GQ6003@kernel.dk>
In-Reply-To: <20130218135756.GQ6003@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Am 18.02.2013 14:57, schrieb Jens Axboe:
> On Thu, Feb 14 2013, Nikolaus Jeremic wrote:
>> Hi,
>>
>> I've tried to replay I/Os from a textual iolog file to a couple of files
>> using fio 2.0.13 on Linux. However, all I/Os were performed to the last
>> opened file, which is '/mnt/ssd5/rand-write.1.0_1_2' in this example . My
>> jobfile and iolog files contain the following:
>>
>> ############### job file #########
>> [global]
>> name=replay_filetraces
>> description=Replay file traces
>> ioengine=libaio
>> iodepth=6
>> direct=1
>> continue_on_error=1
>>
>> [replay]
>> numjobs=1
>> read_iolog=file_io_patterns
>> unlink=0
>> ############## EOF #########
>>
>>
>> ############## iolog file #########
>> fio version 2 iolog
>> /mnt/ssd0/rand-write.1.0_0_0 add
>> /mnt/ssd1/rand-write.1.0_0_1 add
>> /mnt/ssd2/rand-write.1.0_0_2 add
>> /mnt/ssd3/rand-write.1.0_1_0 add
>> /mnt/ssd4/rand-write.1.0_1_1 add
>> /mnt/ssd5/rand-write.1.0_1_2 add
>> /mnt/ssd0/rand-write.1.0_0_0 open
>> /mnt/ssd1/rand-write.1.0_0_1 open
>> /mnt/ssd2/rand-write.1.0_0_2 open
>> /mnt/ssd3/rand-write.1.0_1_0 open
>> /mnt/ssd4/rand-write.1.0_1_1 open
>> /mnt/ssd5/rand-write.1.0_1_2 open
>> /mnt/ssd0/rand-write.1.0_0_0 write 0 65536
>> /mnt/ssd1/rand-write.1.0_0_1 write 0 65536
>> /mnt/ssd2/rand-write.1.0_0_2 write 0 65536
>> /mnt/ssd3/rand-write.1.0_1_0 write 0 65536
>> /mnt/ssd4/rand-write.1.0_1_1 write 0 65536
>> /mnt/ssd5/rand-write.1.0_1_2 write 0 65536
>> /mnt/ssd0/rand-write.1.0_0_0 write 65536 65536
>> /mnt/ssd1/rand-write.1.0_0_1 write 65536 65536
>> /mnt/ssd2/rand-write.1.0_0_2 write 65536 65536
>> /mnt/ssd3/rand-write.1.0_1_0 write 65536 65536
>> /mnt/ssd4/rand-write.1.0_1_1 write 65536 65536
>> /mnt/ssd5/rand-write.1.0_1_2 write 65536 65536
>> /mnt/ssd0/rand-write.1.0_0_0 close
>> /mnt/ssd1/rand-write.1.0_0_1 close
>> /mnt/ssd2/rand-write.1.0_0_2 close
>> /mnt/ssd3/rand-write.1.0_1_0 close
>> /mnt/ssd4/rand-write.1.0_1_1 close
>> /mnt/ssd5/rand-write.1.0_1_2 close
>> ############## EOF #########
>>
>> I've turned on debugging and added some extra printf in read_iolog2() within
>> iolog.c.
>>
>> ############## begin of debug excerpt  ########
>> file     24594 add file /mnt/ssd0/rand-write.1.0_0_0
>> file     24594 resize file array to 2 files
>> file     24594 file 0x7fbe03f53090 "/mnt/ssd0/rand-write.1.0_0_0" added at 0
>> file     24594 add file /mnt/ssd1/rand-write.1.0_0_1
>> file     24594 file 0x7fbe03f53230 "/mnt/ssd1/rand-write.1.0_0_1" added at 1
>> file     24594 add file /mnt/ssd2/rand-write.1.0_0_2
>> file     24594 resize file array to 4 files
>> file     24594 file 0x7fbe03f533d0 "/mnt/ssd2/rand-write.1.0_0_2" added at 2
>> file     24594 add file /mnt/ssd3/rand-write.1.0_1_0
>> file     24594 file 0x7fbe03f53570 "/mnt/ssd3/rand-write.1.0_1_0" added at 3
>> file     24594 add file /mnt/ssd4/rand-write.1.0_1_1
>> file     24594 resize file array to 6 files
>> file     24594 file 0x7fbe03f53710 "/mnt/ssd4/rand-write.1.0_1_1" added at 4
>> file     24594 add file /mnt/ssd5/rand-write.1.0_1_2
>> file     24594 file 0x7fbe03f538b0 "/mnt/ssd5/rand-write.1.0_1_2" added at 5
>> io       24594 read_iolog2: Making note of file. offset=7310584035475809390
>> bytes=811544671 fileno=0 file_action=1 fname=/mnt/ssd0/rand-write.1.0_0_0
>> act=open
>> io       24594 read_iolog2: Making note of file. offset=7310584035475809390
>> bytes=811544671 fileno=1 file_action=1 fname=/mnt/ssd1/rand-write.1.0_0_1
>> act=open
>> io       24594 read_iolog2: Making note of file. offset=7310584035475809390
>> bytes=811544671 fileno=2 file_action=1 fname=/mnt/ssd2/rand-write.1.0_0_2
>> act=open
>> io       24594 read_iolog2: Making note of file. offset=7310584035475809390
>> bytes=811544671 fileno=3 file_action=1 fname=/mnt/ssd3/rand-write.1.0_1_0
>> act=open
>> io       24594 read_iolog2: Making note of file. offset=7310584035475809390
>> bytes=811544671 fileno=4 file_action=1 fname=/mnt/ssd4/rand-write.1.0_1_1
>> act=open
>> io       24594 read_iolog2: Making note of file. offset=7310584035475809390
>> bytes=811544671 fileno=5 file_action=1 fname=/mnt/ssd5/rand-write.1.0_1_2
>> act=open
>> io       24594 read_iolog2: Making note of file. offset=0 bytes=65536
>> fileno=5 file_action=1 fname=/mnt/ssd0/rand-write.1.0_0_0 act=write
>> io       24594 read_iolog2: Making note of file. offset=0 bytes=65536
>> fileno=5 file_action=1 fname=/mnt/ssd1/rand-write.1.0_0_1 act=write
>> io       24594 read_iolog2: Making note of file. offset=0 bytes=65536
>> fileno=5 file_action=1 fname=/mnt/ssd2/rand-write.1.0_0_2 act=write
>> io       24594 read_iolog2: Making note of file. offset=0 bytes=65536
>> fileno=5 file_action=1 fname=/mnt/ssd3/rand-write.1.0_1_0 act=write
>> io       24594 read_iolog2: Making note of file. offset=0 bytes=65536
>> fileno=5 file_action=1 fname=/mnt/ssd4/rand-write.1.0_1_1 act=write
>> io       24594 read_iolog2: Making note of file. offset=0 bytes=65536
>> fileno=5 file_action=1 fname=/mnt/ssd5/rand-write.1.0_1_2 act=write
>> io       24594 read_iolog2: Making note of file. offset=65536 bytes=65536
>> fileno=5 file_action=1 fname=/mnt/ssd0/rand-write.1.0_0_0 act=write
>> io       24594 read_iolog2: Making note of file. offset=65536 bytes=65536
>> fileno=5 file_action=1 fname=/mnt/ssd1/rand-write.1.0_0_1 act=write
>> io       24594 read_iolog2: Making note of file. offset=65536 bytes=65536
>> fileno=5 file_action=1 fname=/mnt/ssd2/rand-write.1.0_0_2 act=write
>> io       24594 read_iolog2: Making note of file. offset=65536 bytes=65536
>> fileno=5 file_action=1 fname=/mnt/ssd3/rand-write.1.0_1_0 act=write
>> io       24594 read_iolog2: Making note of file. offset=65536 bytes=65536
>> fileno=5 file_action=1 fname=/mnt/ssd4/rand-write.1.0_1_1 act=write
>> io       24594 read_iolog2: Making note of file. offset=65536 bytes=65536
>> fileno=5 file_action=1 fname=/mnt/ssd5/rand-write.1.0_1_2 act=write
>> io       24594 read_iolog2: Making note of file. offset=65536 bytes=65536
>> fileno=0 file_action=2 fname=/mnt/ssd0/rand-write.1.0_0_0 act=close
>> io       24594 read_iolog2: Making note of file. offset=65536 bytes=65536
>> fileno=1 file_action=2 fname=/mnt/ssd1/rand-write.1.0_0_1 act=close
>> io       24594 read_iolog2: Making note of file. offset=65536 bytes=65536
>> fileno=2 file_action=2 fname=/mnt/ssd2/rand-write.1.0_0_2 act=close
>> io       24594 read_iolog2: Making note of file. offset=65536 bytes=65536
>> fileno=3 file_action=2 fname=/mnt/ssd3/rand-write.1.0_1_0 act=close
>> io       24594 read_iolog2: Making note of file. offset=65536 bytes=65536
>> fileno=4 file_action=2 fname=/mnt/ssd4/rand-write.1.0_1_1 act=close
>> io       24594 read_iolog2: Making note of file. offset=65536 bytes=65536
>> fileno=5 file_action=2 fname=/mnt/ssd5/rand-write.1.0_1_2 act=close
>> ############## end of debug excerpt  ########
>>
>> Taking a look to the debugging output shows that on write action the
>> 'fileno' variable is always set to 5 regardless of the file that should be
>> written. However, for open and close we have a different fileno value for
>> each file. Taking a look into the source code of read_iolog2() reveals why:
>> In case of actions 'open' or 'close', 'fileno' is looked up through
>> 'get_fileno(td, fname)', but for 'write', 'read' and the other 4 argument
>> actions 'fileno' is not looked up. When I add a 'fileno = get_fileno(td,
>> fname);' at the end of the '(r == 4)' branch, I/Os are replayed to the
>> designated files.
>>
>> ########## excerpt from read_iolog2() within iolog.c ######
>>                  if (r == 4) {
>>                          /*
>>                           * Check action first
>>                           */
>>                          if (!strcmp(act, "wait"))
>>                                  rw = DDIR_WAIT;
>>                          else if (!strcmp(act, "read"))
>>                                  rw = DDIR_READ;
>>                          else if (!strcmp(act, "write"))
>>                                  rw = DDIR_WRITE;
>>                          else if (!strcmp(act, "sync"))
>>                                  rw = DDIR_SYNC;
>>                          else if (!strcmp(act, "datasync"))
>>                                  rw = DDIR_DATASYNC;
>>                          else if (!strcmp(act, "trim"))
>>                                  rw = DDIR_TRIM;
>>                          else {
>>                                  log_err("fio: bad iolog file action: %s\n",
>> act);
>>                                  continue;
>>                          }
>>                  } else if (r == 2) {
>>                          rw = DDIR_INVAL;
>>                          if (!strcmp(act, "add")) {
>>                                  td->o.nr_files++;
>>                                  fileno = add_file(td, fname);
>>                                  file_action = FIO_LOG_ADD_FILE;
>>                                  continue;
>>                          } else if (!strcmp(act, "open")) {
>>                                  fileno = get_fileno(td, fname);
>>                                  file_action = FIO_LOG_OPEN_FILE;
>>                          } else if (!strcmp(act, "close")) {
>>                                  fileno = get_fileno(td, fname);
>>                                  file_action = FIO_LOG_CLOSE_FILE;
>>                          } else {
>>                                  log_err("fio: bad iolog file action: %s\n",
>> act);
>>                                  continue;
>>                          }
>>                  } else {
>>                          log_err("bad iolog2: %s", p);
>>                          continue;
>>                  }
>> ########## end ######
> Thanks for the detailed and thorough analysis. Care to resend this is a
> "proper" patch, and I'll get it tested and added too?
>

Index: fio-2.0.13/iolog.c
===================================================================
--- fio-2.0.13/iolog.c    (revision 807)
+++ fio-2.0.13/iolog.c    (revision 863)
@@ -316,6 +316,7 @@
                                      act);
                  continue;
              }
+            fileno = get_fileno(td, fname);
          } else if (r == 2) {
              rw = DDIR_INVAL;
              if (!strcmp(act, "add")) {



-- 
Dipl.-Inf. Nikolaus Jeremic          nikolaus.jeremic@uni-rostock.de
Universitaet Rostock                 Tel:  (+49) 381 / 498 - 7635
Albert-Einstein-Str. 22	             Fax:  (+49) 381 / 498 - 7482
18059 Rostock, Germany               wwwava.informatik.uni-rostock.de


