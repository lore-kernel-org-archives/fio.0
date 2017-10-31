Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <BN6PR11MB2034645770AE02D7AC6D4350875E0@BN6PR11MB2034.namprd11.prod.outlook.com>
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
 <CALjAwxiS8XOFhwweHRND3ocJFY2FH_aud=9_OXtbWAM7-b1LJQ@mail.gmail.com> <BN6PR11MB2034645770AE02D7AC6D4350875E0@BN6PR11MB2034.namprd11.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 31 Oct 2017 23:27:13 +0000
Message-ID: <CALjAwxiYOyX7UOGRpFs7ydx9RqnZ2JtOtg-pUupLUexY4bpqXw@mail.gmail.com>
Subject: Re: FIO windows
Content-Type: text/plain; charset="UTF-8"
To: David Hare <david.hare@primarydata.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi,

You might find some useful tips in previous "go faster" fio mailing
list threads like https://www.spinics.net/lists/fio/msg05984.html  .

On 31 October 2017 at 23:07, David Hare <david.hare@primarydata.com> wrote:
> Just a little back story, I am testing a 88core Dell R930 with 30 NVMe
> drives, (6) Kingston PCIe NVMe each has 4 m.2 drive ie. 24 drives. Then
> there is (6) 2.5" NVMe u.2 drives.
>
> I started out with my usual tools benchmark tools and was not able to get
> anything above 36GB/s and I had to run the multiple version of the tools at
> the same time.
>
> I found Diskspd for windows and it has a lot of control with threads and
> affinity I was able to reach 52.7GB/s which is pretty close to theoretical
> max of the drives of about 56GB/s.
>
> I am trying to achieve the same results or close with FIO so I can compares
> Windows with Centos and ultimately our version of Redhat. I am having issue
> tuning FIO much above 14GB/s

-- 
Sitsofe | http://sucs.org/~sits/

