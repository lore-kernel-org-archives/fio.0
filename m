Return-Path: <axboe@kernel.dk>
Subject: Re: FIO windows
References: <MWHPR11MB2045B4FFEB905261E1FAFD1E875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <MWHPR11MB20457601992059B3E7C48865875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <CALjAwxi+1Djmm_0SqEDTYV_Oc5yBDZYyak1Vd3S6Bsr8BNjjqg@mail.gmail.com>
 <MWHPR11MB204592682060845766230A8D875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <CALjAwxiNeLuF2QSf6rg5wF4rLv47Fc=XreZR1pQf6V9zjiTy6A@mail.gmail.com>
 <MWHPR11MB2045F05DB9FFF9FA44A04E6F875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <CALjAwxgAOCNQbWUw+eTiu3J2ZprXpmxpezLe53eFno0s0oaFDQ@mail.gmail.com>
 <MWHPR11MB2045A9D5365FF57AC31CC87D875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <CALjAwxjsP=r87NXxurSXa86YUt7orCuPTAK=Gu3qfpUaUcCV5w@mail.gmail.com>
 <MWHPR11MB2045A939088A8133BB30CDEB875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <CALjAwxiS8XOFhwweHRND3ocJFY2FH_aud=9_OXtbWAM7-b1LJQ@mail.gmail.com>
 <BN6PR11MB2034DE8B819C36DCD434DD22875E0@BN6PR11MB2034.namprd11.prod.outlook.com>
 <CALjAwxh7+MaSkamGrxS5u6Vkv7eZYu-mAWW4pDnQmP-WpK+KJw@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <e5107a87-6560-00b0-ed5d-98539fc7bad8@kernel.dk>
Date: Wed, 1 Nov 2017 10:44:32 -0600
MIME-Version: 1.0
In-Reply-To: <CALjAwxh7+MaSkamGrxS5u6Vkv7eZYu-mAWW4pDnQmP-WpK+KJw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>, David Hare <david.hare@primarydata.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

I just tried to reproduce on Linux, and I can. If the files don't exist and
I run this job:

[global]
blocksize=64k
direct=1
group_reporting
rw=read
size=512m

[asdf]
filename=testfile1:testfile2:testfile3

it works fine. Then I change the size to be 250m AND add time_based
and a longer runtime to ensure we hit the roll-around, and it fails:

fio win.fio 
asdf: (g=0): rw=read, bs=(R) 64.0KiB-64.0KiB, (W) 64.0KiB-64.0KiB, (T) 64.0KiB-64.0KiB, ioengine=psync, iodepth=1
fio-3.1-76-g08bd-dirty
Starting 1 process
fio: io_u error on file testfile1: Invalid argument: read offset=21846, buflen=65536
fio: pid=18198, err=22/file:io_u.c:1770, func=io_u error, error=Invalid argument

So looks like a bug in the reset part. I'll take a look.


On 10/31/2017 05:06 PM, Sitsofe Wheeler wrote:
> OK I see the problem too when using this on Windows:
> $ ./fio --size=1g --filename
> fio1.tmp:fio2.tmp:fio3.tmp:fio4.tmp:fio5.tmp:fio6.tmp:fio7.tmp:fio8.tmp:fio9.tmp
> --name=go --create_only=1
> $ ./fio --size=250m --filename fio1.tmp:fio2.tmp:fio3.tmp --name=go
> --direct=1 --bs=64k --runtime=1m --time_based --thread
> 
> Using --debug=all shows the following:
> io       2796  getevents: 1
> io       2796  io complete: io_u 0000000007BD8F00:
> off=87359488/len=65536/ddir=0io       2796  /fio3.tmpio       2796
> file     2796  put file fio3.tmp, ref=2
> file     2796  trying file fio1.tmp 11
> file     2796  goodf=1, badf=2, ff=11
> file     2796  get_next_file_rr: 00007FF5FEEA4610
> file     2796  get_next_file: 00007FF5FEEA4610 [fio1.tmp]
> file     2796  get file fio1.tmp, ref=1
> io       2796  fill_io_u: io_u 0000000007BD8F00:
> off=21846/len=65536/ddir=0io       2796  /fio1.tmpio       2796
> io       2796  prep: io_u 0000000007BD8F00:
> off=21846/len=65536/ddir=0io       2796  /fio1.tmpio       2796
> io       2796  queue: io_u 0000000007BD8F00:
> off=21846/len=65536/ddir=0io       2796  /fio1.tmpio
> helperthread 2796
> 2796  since_ss: 0, next_ss: 1000, next_log: 495, msec_to_next_event: 136
> file     2796  put file fio1.tmp, ref=2
> io       2796  io_u_queued_complete: min=0
> io       2796  getevents: 0
> process  2796  pid=2936: runstate RUNNING -> FINISHING
> fio: pid=2936, err=22/file:ioengines.c:335, func=td_io_queue,
> error=Invalid argument
> 
> off=21846 is not a multiple of 512.
> 
> $ du -b fio*tmp
> 119304647       fio1.tmp
> 119304647       fio2.tmp
> 119304647       fio3.tmp
> 119304647       fio4.tmp
> 119304647       fio5.tmp
> 119304647       fio6.tmp
> 119304647       fio7.tmp
> 119304647       fio8.tmp
> 119304647       fio9.tmp
> 
> I think this is all hinting at a bug in fio (perhaps when working with
> multiple pre-existing files that are bigger than size specified) but I
> think I'm done for the day...
> 
> On 31 October 2017 at 22:51, David Hare <david.hare@primarydata.com> wrote:
>>
>> Not sure what you mean by one file? The drives are local NTFS formatted with
>> Allocation unit size of 64k, they range in size from with are 186gb - 372gb.
> 


-- 
Jens Axboe


