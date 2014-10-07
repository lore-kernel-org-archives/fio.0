Return-Path: <axboe@kernel.dk>
Message-ID: <54346A66.6000509@kernel.dk>
Date: Tue, 07 Oct 2014 16:34:14 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FIO - Client and Server - Suggestion
References: <D0599D7A.51F81%Antonio.Jose.Rodrigues.Neto@netapp.com> <54345B52.7060306@kernel.dk> <543462BE.3000101@kernel.dk> <D059DCD3.52059%Antonio.Jose.Rodrigues.Neto@netapp.com> <D059DD71.5205D%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <D059DD71.5205D%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10/07/2014 04:11 PM, Neto, Antonio Jose Rodrigues wrote:
> 
> 
> On 10/7/14, 6:09 PM, "Neto, Antonio Jose Rodrigues"
> <Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
> 
>>
>>
>> On 10/7/14, 6:01 PM, "Jens Axboe" <axboe@kernel.dk> wrote:
>>
>>> On 10/07/2014 03:29 PM, Jens Axboe wrote:
>>>> On 10/07/2014 11:38 AM, Neto, Antonio Jose Rodrigues wrote:
>>>>> Hi All,
>>>>>
>>>>> This is neto from Brazil
>>>>>
>>>>> How are you?
>>>>>
>>>>> One small suggestion:
>>>>>
>>>>> Running Client and Server architecture on FIO, we need to have all
>>>>> config
>>>>> files "locally" to run it.
>>>>>
>>>>>
>>>>> Nossa Senhora:tools neto$ ls
>>>>> 151 152 fio
>>>>>
>>>>>
>>>>>
>>>>> Nossa Senhora:tools neto$ ./fio --client 10.61.109.151 151 --client
>>>>> 10.61.109.152 152
>>>>> hostname=s2, be=0, 64-bit, os=Linux, arch=x86-64,
>>>>> fio=fio-2.1.13-31-g15e3,
>>>>> flags=1
>>>>> hostname=s1, be=0, 64-bit, os=Linux, arch=x86-64,
>>>>> fio=fio-2.1.13-31-g15e3,
>>>>> flags=1
>>>>> <s2> workload: (g=0): rw=read, <s1> workload: (g=0): rw=read,
>>>>> bs=64K-64K/64K-64K/64K-64K, bs=64K-64K/64K-64K/64K-64K,
>>>>> ioengine=libaio,
>>>>> iodepth=1
>>>>> ioengine=libaio, iodepth=1
>>>>>
>>>>> If we are doing a test in an HPC environment with hundred of files,
>>>>> wouldn't be easier to try to point to a single location for the file
>>>>> and
>>>>> access it remotely (we won't need to copy it locally).
>>>>>
>>>>>
>>>>> For example:
>>>>>
>>>>> ./fio --client 10.61.109.151 --remote-config /root/fio/151 --client
>>>>> 10.61.109.152 --remote-config /root/fio/152
>>>>>
>>>>>
>>>>> Thoughts?
>>>>
>>>> That's a good idea, would not be hard to insert that step of having the
>>>> remote fio server load a local config file. I'll look into that.
>>>
>>> Totally untested, but the below is a start. On the client side, you'd do:
>>>
>>> fio --client=server-hostname --remote-config /some/path/to/file
>>>
>>> and then the server should attempt to open that. Needs a bit of error
>>> handling, but the concept should be there.
>>>
>>> -- 
>>> Jens Axboe
>>
>>
>> Hi Jens,
>>
>> This is neto from Brazil
>>
>> How are you?
>>
>> I think it is not working.... Please see below:
>>
>> Nossa Senhora:fio.patch neto$ ./fio --client 10.61.109.151 --remote-config
>> /root/fio.patch/model
>> hostname=s1, be=0, 64-bit, os=Linux, arch=x86-64, fio=fio-2.1.13-31-g15e3,
>> flags=1
>>
>> Thank you,
>>
>>
>> neto
> 
> On server side, I've got:
> 
> [root@s1 fio.patch]# ./fio --server
> fio: server listening on 0.0.0.0,8765
> fopen job file: No such file or directory
> fopen job file: No such file or directory
> fopen job file: No such file or directory
> fopen job file: No such file or directory
> fopen job file: No such file or directory
> fopen job file: No such file or directory
> fopen job file: No such file or directory
> fopen job file: No such file or directory

Just to be sure, when you use --remote-config /root/fio.patch/model,
then it will open /root/fio.patch/model on the s1 machine running fio
--server.

Ran a quick test here, and it seems to work for me. The fio --server
opens the file at the given path, not the client. If you wanted the
client to open it, you'd just do

fio --client 10.61.109.151 /root/fio.patch/model

and it'd do the opposite - load the file on the client side, and send it
to the server.

-- 
Jens Axboe


