Return-Path: <fio-owner@vger.kernel.org>
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:59747 "HELO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754758Ab3L1BoV convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 27 Dec 2013 20:44:21 -0500
From: Todd Dworshak <todd.dworshak@avid.com>
Subject: fio 2.1.4 intermittently crashes on windows
Date: Sat, 28 Dec 2013 01:42:03 +0000
Message-ID: <0C4FACE8A034424CB177F7934C49B4ED080FE9AF@WAL-MBS04.global.avidww.com>
Content-Language: en-US
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi =EF=BF=BD

I am having trouble with fio intermittently crashing on Windows 7.

Version is fio 2.1.4 64 bit, downloaded from Windows build site.

Has anyone else seen this?  If I give it fewer files in the job description=
, it seems to be less prone to crashing.  Since it crashes in pthreads, it =
looks like this may be some kind of threading bug.

Call stack of fio dump file is as follows:
                kernel32.dll!WerpReportFaultInternal()  + 0x215 bytes =20
               kernel32.dll!WerpReportFault()  + 0x77 bytes    =20
               kernel32.dll!BasepReportFault()  + 0x1f bytes   =20
               kernel32.dll!UnhandledExceptionFilter()  + 0x1fc bytes =20
               ntdll.dll!string "Enabling heap debug options\n"()  + 0xc9c8=
 bytes            =20
               ntdll.dll!__C_specific_handler()  + 0x9c bytes    =20
               ntdll.dll!RtlpExecuteHandlerForException()  + 0xd bytes     =
          =20
               ntdll.dll!RtlDispatchException()  + 0x38f bytes   =20
               ntdll.dll!RtlRaiseStatus()  + 0x60 bytes   =20
               ntdll.dll!string "Enabling heap debug options\n"()  - 0x17a4=
e bytes          =20
               ntdll.dll!KiUserExceptionDispatcher()  + 0x2e bytes         =

               libwinpthread-1.dll!0000000064943236()              =20
                [Frames below may be incorrect and/or missing, no symbols l=
oaded for libwinpthread-1.dll]      =20
               000000000000000a()      =20
               fio.exe!0000000000421599()      =20
                fio.exe!0000000000437ce0()      =20
                fio.exe!000000000043809d()      =20
                fio.exe!00000000004013a5()      =20
                fio.exe!00000000004014d8()      =20
                kernel32.dll!BaseThreadInitThunk()  + 0xd bytes            =
  =20
               ntdll.dll!RtlUserThreadStart()  + 0x21 bytes         =20

Job description follows:

[global]
ioengine=3Dwindowsaio
buffered=3D0
rw=3Dread
bs=3D4m
size=3D4000m
iodepth=3D3
runtime=3D90

[file1]
filename=3Dz\:\test1a.dat
rate=3D80m

[file2]
filename=3Dz\:\test2a.dat
rate=3D80m

[file3]
filename=3Dz\:\test3a.dat
rate=3D80m

[file4]
filename=3Dz\:\test4a.dat
rate=3D80m

[file5]
filename=3Dz\:\test5a.dat
rate=3D80m

[file6]
filename=3Dz\:\test6a.dat
rate=3D80m

[file7]
filename=3Dz\:\test7a.dat
rate=3D80m

[file8]
filename=3Dz\:\test8a.dat
rate=3D80m

[file9]
filename=3Dz\:\test9a.dat
rate=3D80m

[file10]
filename=3Dz\:\test10a.dat
rate=3D80m

Thanks in advance for any help you can provide.

Todd Dworshak