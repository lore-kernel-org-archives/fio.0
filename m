Return-Path: <Antonio.Jose.Rodrigues.Neto@netapp.com>
From: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: FIO - Client and Server - Suggestion
Date: Wed, 8 Oct 2014 01:19:13 +0000
Message-ID: <D05A0920.520A9%Antonio.Jose.Rodrigues.Neto@netapp.com>
References: <D0599D7A.51F81%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <54345B52.7060306@kernel.dk> <543462BE.3000101@kernel.dk>
 <D059DCD3.52059%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <D059DD71.5205D%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <54346A66.6000509@kernel.dk>
 <40C9565A-0AB9-413A-B342-F5EF247686E5@netapp.com>
 <D05A0624.520A1%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <D05A0624.520A1%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <63D12949963A0E44B6904E84D53C59A8@hq.netapp.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



On 10/7/14, 9:07 PM, "Neto, Antonio Jose Rodrigues"
<Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:

>
>
>On 10/7/14, 6:44 PM, "Neto, Antonio Jose Rodrigues"
><Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
>
>>
>>
>>
>>
>>> On Oct 7, 2014, at 6:33 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>=20
>>>> On 10/07/2014 04:11 PM, Neto, Antonio Jose Rodrigues wrote:
>>>>=20
>>>>=20
>>>> On 10/7/14, 6:09 PM, "Neto, Antonio Jose Rodrigues"
>>>> <Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
>>>>=20
>>>>>=20
>>>>>=20
>>>>>> On 10/7/14, 6:01 PM, "Jens Axboe" <axboe@kernel.dk> wrote:
>>>>>>=20
>>>>>>> On 10/07/2014 03:29 PM, Jens Axboe wrote:
>>>>>>>> On 10/07/2014 11:38 AM, Neto, Antonio Jose Rodrigues wrote:
>>>>>>>> Hi All,
>>>>>>>>=20
>>>>>>>> This is neto from Brazil
>>>>>>>>=20
>>>>>>>> How are you?
>>>>>>>>=20
>>>>>>>> One small suggestion:
>>>>>>>>=20
>>>>>>>> Running Client and Server architecture on FIO, we need to have all
>>>>>>>> config
>>>>>>>> files "locally" to run it.
>>>>>>>>=20
>>>>>>>>=20
>>>>>>>> Nossa Senhora:tools neto$ ls
>>>>>>>> 151 152 fio
>>>>>>>>=20
>>>>>>>>=20
>>>>>>>>=20
>>>>>>>> Nossa Senhora:tools neto$ ./fio --client 10.61.109.151 151
>>>>>>>>--client
>>>>>>>> 10.61.109.152 152
>>>>>>>> hostname=3Ds2, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
>>>>>>>> fio=3Dfio-2.1.13-31-g15e3,
>>>>>>>> flags=3D1
>>>>>>>> hostname=3Ds1, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
>>>>>>>> fio=3Dfio-2.1.13-31-g15e3,
>>>>>>>> flags=3D1
>>>>>>>> <s2> workload: (g=3D0): rw=3Dread, <s1> workload: (g=3D0): rw=3Dre=
ad,
>>>>>>>> bs=3D64K-64K/64K-64K/64K-64K, bs=3D64K-64K/64K-64K/64K-64K,
>>>>>>>> ioengine=3Dlibaio,
>>>>>>>> iodepth=3D1
>>>>>>>> ioengine=3Dlibaio, iodepth=3D1
>>>>>>>>=20
>>>>>>>> If we are doing a test in an HPC environment with hundred of
>>>>>>>>files,
>>>>>>>> wouldn't be easier to try to point to a single location for the
>>>>>>>>file
>>>>>>>> and
>>>>>>>> access it remotely (we won't need to copy it locally).
>>>>>>>>=20
>>>>>>>>=20
>>>>>>>> For example:
>>>>>>>>=20
>>>>>>>> ./fio --client 10.61.109.151 --remote-config /root/fio/151
>>>>>>>>--client
>>>>>>>> 10.61.109.152 --remote-config /root/fio/152
>>>>>>>>=20
>>>>>>>>=20
>>>>>>>> Thoughts?
>>>>>>>=20
>>>>>>> That's a good idea, would not be hard to insert that step of having
>>>>>>>the
>>>>>>> remote fio server load a local config file. I'll look into that.
>>>>>>=20
>>>>>> Totally untested, but the below is a start. On the client side,
>>>>>>you'd do:
>>>>>>=20
>>>>>> fio --client=3Dserver-hostname --remote-config /some/path/to/file
>>>>>>=20
>>>>>> and then the server should attempt to open that. Needs a bit of
>>>>>>error
>>>>>> handling, but the concept should be there.
>>>>>>=20
>>>>>> --=20
>>>>>> Jens Axboe
>>>>>=20
>>>>>=20
>>>>> Hi Jens,
>>>>>=20
>>>>> This is neto from Brazil
>>>>>=20
>>>>> How are you?
>>>>>=20
>>>>> I think it is not working.... Please see below:
>>>>>=20
>>>>> Nossa Senhora:fio.patch neto$ ./fio --client 10.61.109.151
>>>>>--remote-config
>>>>> /root/fio.patch/model
>>>>> hostname=3Ds1, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
>>>>>fio=3Dfio-2.1.13-31-g15e3,
>>>>> flags=3D1
>>>>>=20
>>>>> Thank you,
>>>>>=20
>>>>>=20
>>>>> neto
>>>>=20
>>>> On server side, I've got:
>>>>=20
>>>> [root@s1 fio.patch]# ./fio --server
>>>> fio: server listening on 0.0.0.0,8765
>>>> fopen job file: No such file or directory
>>>> fopen job file: No such file or directory
>>>> fopen job file: No such file or directory
>>>> fopen job file: No such file or directory
>>>> fopen job file: No such file or directory
>>>> fopen job file: No such file or directory
>>>> fopen job file: No such file or directory
>>>> fopen job file: No such file or directory
>>>=20
>>> Just to be sure, when you use --remote-config /root/fio.patch/model,
>>> then it will open /root/fio.patch/model on the s1 machine running fio
>>> --server.
>>>=20
>>> Ran a quick test here, and it seems to work for me. The fio --server
>>> opens the file at the given path, not the client. If you wanted the
>>> client to open it, you'd just do
>>>=20
>>> fio --client 10.61.109.151 /root/fio.patch/model
>>>=20
>>> and it'd do the opposite - load the file on the client side, and send
>>>it
>>> to the server.
>>>=20
>>> --=20
>>> Jens Axboe
>>>=20
>>
>>I will try again tonight but it did not work
>>
>>My client is on mac and servers are on linux
>
>
>
>Hi Jens,
>
>This is neto from Brazil
>
>How are you?
>
>I found what is happening
>
>If I use a non absolute path it works: the remote config should be on the
>same directory with fio
>
>
>Nossa Senhora:fio.patch neto$ ./fio --client 10.61.109.151 --remote-config
>conf3
>
>
>
>If I specify an absolute path, it does not work
>
>Nossa Senhora:fio.patch neto$ ./fio --client 10.61.109.151 --remote-config
>/root/fio.patch/conf3
>hostname=3Ds1, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64, fio=3Dfio-2.1.13=
-31-g15e3,
>flags=3D1
>
>
>Do you think we could fix it to make sure we can use --remote-config with
>an absolute path?
>
>Thanks
>
>neto
>


Also, another thing that I have figured out is (not sure if this was by
design or not)


Nossa Senhora:fio.patch neto$ ./fio --client 10.61.109.151 --remote-config
model --client 10.61.109.152 --remote-config model
hostname=3Ds2, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64, fio=3Dfio-2.1.13-=
31-g15e3,
flags=3D1
hostname=3Ds1, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64, fio=3Dfio-2.1.13-=
31-g15e3,
flags=3D1
<s2> workload: (g=3D0): rw=3Dread, bs=3D64K-64K/64K-64K/64K-64K, <s1> workl=
oad:
(g=3D0): rw=3Dread, ioengine=3Dlibaio, iodepth=3D1
bs=3D64K-64K/64K-64K/64K-64K, <s2> ...
ioengine=3Dlibaio, iodepth=3D1
<s1> ...
<s2> Starting <s1> Starting 128 threads
128 threads
Jobs: 0 (f=3D0)
Jobs: 0 (f=3D0)


Jobs: 0 (f=3D0)
Jobs: 0 (f=3D0)





Running client and server, we do not have the progress (%) and IOPS and
KB/s and the time....

Is this expected?

Thank you,

neto


