Return-Path: <zhu.yanhai@gmail.com>
MIME-Version: 1.0
In-Reply-To: <116197A0179A3D4A95B135E5F0341FC11041B4D2@SACMVEXC2-PRD.hq.netapp.com>
References: <116197A0179A3D4A95B135E5F0341FC11041B4D2@SACMVEXC2-PRD.hq.netapp.com>
From: Zhu Yanhai <zhu.yanhai@gmail.com>
Date: Sat, 3 Sep 2011 08:00:14 +0800
Message-ID: <CAC8teKVfLCD2nZQyiyt11ovwqm1dsCPn6qcEf+qDxNcqM4ACPA@mail.gmail.com>
Subject: Re: Bad performance when reads and writes on same LUN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "Rettl, Matthias" <Matthias.Rettl@netapp.com>, axboe@kernel.dk, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Yes, I think so.

2011/9/3 Neto, Antonio Jose Rodrigues <Antonio.Jose.Rodrigues.Neto@netapp.c=
om>:
> What do you suggest?
>
> Direct=3D1 for both?
>
> ----- Original Message -----
> From: Zhu Yanhai <zhu.yanhai@gmail.com>
> To: Rettl, Matthias
> Cc: Jens Axboe <axboe@kernel.dk>; Neto, Antonio Jose Rodrigues;
> fio@vger.kernel.org <fio@vger.kernel.org>
> Sent: Fri Sep 02 16:43:54 2011
> Subject: Re: Bad performance when reads and writes on same LUN
>
> Hi,
> Why did you mix buffered aio read with unbuffered (direct io) aio write?
> Buffered aio will fall back to sync io, and it's known that mixing
> with buffered io with direct io will hurt performance.
>
> Regards,
> Zhu Yanhai
>
> 2011/9/2 Rettl, Matthias <Matthias.Rettl@netapp.com>:
>> Hi fio users and developers,
>>
>> I am working on a setup for a customer with a very specific FIO
>> configuration:
>> We have to use 8 LUNs (from a very performant storage system, by the
>> way), doing three readers and one writer per LUN.
>>
>> So we use 8 fio config files, each of them look the same, except the
>> directory=3D entry:
>>
>> [global]
>> directory=3D/n1-dm-0
>> rw=3Drandread
>> ioengine=3Dlibaio
>> iodepth=3D4
>> size=3D1024m
>> invalidate=3D1
>> direct=3D0
>> runtime=3D60
>> time_based
>>
>> [Reader-1]
>>
>> [Reader-2]
>>
>> [Reader-3]
>>
>> [Writer]
>> rw=3Drandwrite
>> ioengine=3Dlibaio
>> iodepth=3D32
>> direct=3D1
>>
>>
>> When running this configurations (8 fio's in parallel) I receive these
>> results (grep'ed iops from the 8 out-files):
>> =C2=A0read : io=3D128520KB, bw=3D2141.1KB/s, iops=3D535 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D127048KB, bw=3D2117.5KB/s, iops=3D529 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D126816KB, bw=3D2113.6KB/s, iops=3D528 , runt=3D 60001m=
sec
>> =C2=A0write: io=3D3811.8MB, bw=3D65052KB/s, iops=3D16263 , runt=3D 60001=
msec
>> =C2=A0read : io=3D123704KB, bw=3D2061.7KB/s, iops=3D515 , runt=3D 60004m=
sec
>> =C2=A0read : io=3D123656KB, bw=3D2060.9KB/s, iops=3D515 , runt=3D 60002m=
sec
>> =C2=A0read : io=3D122924KB, bw=3D2048.7KB/s, iops=3D512 , runt=3D 60004m=
sec
>> =C2=A0write: io=3D3761.8MB, bw=3D64187KB/s, iops=3D16046 , runt=3D 60002=
msec
>> =C2=A0read : io=3D127636KB, bw=3D2127.3KB/s, iops=3D531 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D126440KB, bw=3D2107.4KB/s, iops=3D526 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D125612KB, bw=3D2093.6KB/s, iops=3D523 , runt=3D 60001m=
sec
>> =C2=A0write: io=3D3832.4MB, bw=3D65403KB/s, iops=3D16350 , runt=3D 60002=
msec
>> =C2=A0read : io=3D125344KB, bw=3D2089.4KB/s, iops=3D522 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D125284KB, bw=3D2088.4KB/s, iops=3D522 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D125080KB, bw=3D2084.7KB/s, iops=3D521 , runt=3D 60001m=
sec
>> =C2=A0write: io=3D3784.8MB, bw=3D64592KB/s, iops=3D16147 , runt=3D 60001=
msec
>> =C2=A0read : io=3D127656KB, bw=3D2127.6KB/s, iops=3D531 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D127144KB, bw=3D2119.4KB/s, iops=3D529 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D126248KB, bw=3D2104.1KB/s, iops=3D526 , runt=3D 60001m=
sec
>> =C2=A0write: io=3D3828.9MB, bw=3D65343KB/s, iops=3D16335 , runt=3D 60002=
msec
>> =C2=A0read : io=3D124236KB, bw=3D2070.6KB/s, iops=3D517 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D123908KB, bw=3D2065.2KB/s, iops=3D516 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D123352KB, bw=3D2055.9KB/s, iops=3D513 , runt=3D 60001m=
sec
>> =C2=A0write: io=3D3764.1MB, bw=3D64253KB/s, iops=3D16063 , runt=3D 60001=
msec
>> =C2=A0read : io=3D127784KB, bw=3D2129.8KB/s, iops=3D532 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D127276KB, bw=3D2121.3KB/s, iops=3D530 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D127240KB, bw=3D2120.7KB/s, iops=3D530 , runt=3D 60001m=
sec
>> =C2=A0write: io=3D3839.5MB, bw=3D65524KB/s, iops=3D16380 , runt=3D 60002=
msec
>> =C2=A0read : io=3D124864KB, bw=3D2081.4KB/s, iops=3D520 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D124008KB, bw=3D2066.8KB/s, iops=3D516 , runt=3D 60002m=
sec
>> =C2=A0read : io=3D124068KB, bw=3D2067.8KB/s, iops=3D516 , runt=3D 60001m=
sec
>> =C2=A0write: io=3D3748.9MB, bw=3D63979KB/s, iops=3D15994 , runt=3D 60001=
msec
>>
>>
>> As you can see, read-performance is very bad! Writes are fine, but reads
>> are not acceptable!
>> By the way, for reads the parameter "direct=3D0" is set and I can see th=
at
>> the reads are not even hitting the storage system!
>>
>> I have then tried to remove the writers from the fio config files, and
>> the read-results are as we would expect it:
>>
>> =C2=A0read : io=3D1522.1MB, bw=3D25977KB/s, iops=3D6494 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D1526.3MB, bw=3D26047KB/s, iops=3D6511 , runt=3D 60000m=
sec
>> =C2=A0read : io=3D1526.9MB, bw=3D26058KB/s, iops=3D6514 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D990.98MB, bw=3D16912KB/s, iops=3D4227 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D990.85MB, bw=3D16910KB/s, iops=3D4227 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D1107.5MB, bw=3D18900KB/s, iops=3D4724 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D1006.8MB, bw=3D17181KB/s, iops=3D4295 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D1011.2MB, bw=3D17256KB/s, iops=3D4314 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D1046.2MB, bw=3D17854KB/s, iops=3D4463 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D987.33MB, bw=3D16850KB/s, iops=3D4212 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D991.72MB, bw=3D16925KB/s, iops=3D4231 , runt=3D 60000m=
sec
>> =C2=A0read : io=3D1102.4MB, bw=3D18813KB/s, iops=3D4703 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D1014.8MB, bw=3D17318KB/s, iops=3D4329 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D1012.1MB, bw=3D17287KB/s, iops=3D4321 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D1128.7MB, bw=3D19252KB/s, iops=3D4813 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D1186.1MB, bw=3D20257KB/s, iops=3D5064 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D996.34MB, bw=3D17004KB/s, iops=3D4250 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D1051.6MB, bw=3D17945KB/s, iops=3D4486 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D1012.9MB, bw=3D17286KB/s, iops=3D4321 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D1014.8MB, bw=3D17318KB/s, iops=3D4329 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D1125.5MB, bw=3D19208KB/s, iops=3D4801 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D1125.3MB, bw=3D19204KB/s, iops=3D4800 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D1005.2MB, bw=3D17155KB/s, iops=3D4288 , runt=3D 60001m=
sec
>> =C2=A0read : io=3D1016.7MB, bw=3D17351KB/s, iops=3D4337 , runt=3D 60001m=
sec
>>
>> We are on a RHEL 5.5 Box, 8 Gb FC. With another tool I receive about
>> 180k 4k direct (!) random-read IOPS (with 64 threads to 4 LUNs).
>>
>> We have also tried to use separate read- and write config files. But as
>> soon as we run the tests against the same LUN, read-performance drops!
>>
>> Any feedback is highly appreciated!
>>
>> Cheers,
>> Matt
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
>>
>

