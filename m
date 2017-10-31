Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <BN6PR11MB2034A5144B912434C9363D90875E0@BN6PR11MB2034.namprd11.prod.outlook.com>
References: <MWHPR11MB2045B4FFEB905261E1FAFD1E875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <863271c2-eeb4-b770-bdfa-89746d4d9c70@kernel.dk> <MWHPR11MB2045DFA579DB2BDC5B1EA466875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <2feebb78-c436-3187-f28d-588f18b9dfc4@kernel.dk> <CALjAwxiwWDghXZpsN9vzR7AjwTgHU-g+iYeogbWvO5p6itMd6A@mail.gmail.com>
 <ddbb5d83-cc30-db5f-5c98-0b5809a15d76@kernel.dk> <MWHPR11MB2045095AA21ED4BF8BA38021875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <CALjAwxhx45=uTivppp3A1ACdGmon-oaH9S4b41MJQ6TfQCP7ZA@mail.gmail.com>
 <MWHPR11MB204527783F0D03DE6DE3556D875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <CALjAwxjO0i34McDkRRoeYCxW=CD4WG_=2Aohh=UA34tLL8w3AQ@mail.gmail.com>
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
 <CALjAwxh7+MaSkamGrxS5u6Vkv7eZYu-mAWW4pDnQmP-WpK+KJw@mail.gmail.com> <BN6PR11MB2034A5144B912434C9363D90875E0@BN6PR11MB2034.namprd11.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 31 Oct 2017 23:19:48 +0000
Message-ID: <CALjAwxhf-5Ly3TqggABacLjUAg+y47LoTo17BaND7qVP=Lnxkw@mail.gmail.com>
Subject: Re: FIO windows
Content-Type: text/plain; charset="UTF-8"
To: David Hare <david.hare@primarydata.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi,

Feel free to switch - I think we've got enough to investigate the bug
you were seeing.

On 31 October 2017 at 23:09, David Hare <david.hare@primarydata.com> wrote:
> Ok, its easy for me to switch OS's let me know, when you have something
> ready.
> -Dave
>
> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Tuesday, October 31, 2017 4:06 PM
> To: David Hare <david.hare@primarydata.com>
> Cc: Jens Axboe <axboe@kernel.dk>; fio@vger.kernel.org
> Subject: Re: FIO windows
>
> OK I see the problem too when using this on Windows:
> $ ./fio --size=1g --filename
> fio1.tmp:fio2.tmp:fio3.tmp:fio4.tmp:fio5.tmp:fio6.tmp:fio7.tmp:fio8.tmp:fio9.tmp
> --name=go --create_only=1
> $ ./fio --size=250m --filename fio1.tmp:fio2.tmp:fio3.tmp --name=go
> --direct=1 --bs=64k --runtime=1m --time_based --thread
>
> Using --debug=all shows the following:
> io 2796 getevents: 1
> io 2796 io complete: io_u 0000000007BD8F00:
> off=87359488/len=65536/ddir=0io 2796 /fio3.tmpio 2796
> file 2796 put file fio3.tmp, ref=2
> file 2796 trying file fio1.tmp 11
> file 2796 goodf=1, badf=2, ff=11
> file 2796 get_next_file_rr: 00007FF5FEEA4610
> file 2796 get_next_file: 00007FF5FEEA4610 [fio1.tmp]
> file 2796 get file fio1.tmp, ref=1
> io 2796 fill_io_u: io_u 0000000007BD8F00:
> off=21846/len=65536/ddir=0io 2796 /fio1.tmpio 2796
> io 2796 prep: io_u 0000000007BD8F00:
> off=21846/len=65536/ddir=0io 2796 /fio1.tmpio 2796
> io 2796 queue: io_u 0000000007BD8F00:
> off=21846/len=65536/ddir=0io 2796 /fio1.tmpio
> helperthread 2796
> 2796 since_ss: 0, next_ss: 1000, next_log: 495, msec_to_next_event: 136
> file 2796 put file fio1.tmp, ref=2
> io 2796 io_u_queued_complete: min=0
> io 2796 getevents: 0
> process 2796 pid=2936: runstate RUNNING -> FINISHING
> fio: pid=2936, err=22/file:ioengines.c:335, func=td_io_queue, error=Invalid
> argument
>
> off=21846 is not a multiple of 512.
>
> $ du -b fio*tmp
> 119304647 fio1.tmp
> 119304647 fio2.tmp
> 119304647 fio3.tmp
> 119304647 fio4.tmp
> 119304647 fio5.tmp
> 119304647 fio6.tmp
> 119304647 fio7.tmp
> 119304647 fio8.tmp
> 119304647 fio9.tmp
>
> I think this is all hinting at a bug in fio (perhaps when working with
> multiple pre-existing files that are bigger than size specified) but I think
> I'm done for the day...
>
> On 31 October 2017 at 22:51, David Hare <david.hare@primarydata.com> wrote:
>>
>> Not sure what you mean by one file? The drives are local NTFS
>> formatted with Allocation unit size of 64k, they range in size from with
>> are 186gb - 372gb.
>
> --
> Sitsofe | http://sucs.org/~sits/
>
>
> Disclaimer
>
> The information contained in this communication from the sender is
> confidential. It is intended solely for use by the recipient and others
> authorized to receive it. If you are not the recipient, you are hereby
> notified that any disclosure, copying, distribution or taking action in
> relation of the contents of this information is strictly prohibited and may
> be unlawful.



-- 
Sitsofe | http://sucs.org/~sits/

