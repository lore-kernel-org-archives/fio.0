Return-Path: <axboe@kernel.dk>
Subject: Re: fio crash on windows when using json output
References: <BY2PR0701MB2039BAE87219973B20F0FB8BAFCF0@BY2PR0701MB2039.namprd07.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d8754f54-4c79-62c3-df33-d4f216aaec91@kernel.dk>
Date: Wed, 12 Oct 2016 16:20:27 -0600
MIME-Version: 1.0
In-Reply-To: <BY2PR0701MB2039BAE87219973B20F0FB8BAFCF0@BY2PR0701MB2039.namprd07.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Shahar Glixman <sglixman@velostrata.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Bruce Cran <bruce@cran.org.uk>
List-ID: <fio@vger.kernel.org>

On 09/28/2016 02:21 PM, Shahar Glixman wrote:
> Hello,
>
> I am trying to run fio on windows (2012 core), and getting sporadic crashes  (~ 1 out of 3 runs) -
> Tried both 2.13 (taken from bluestop site: fio-2.13-x64.zip)
> And also compiled 2.14 from sources.
> In both binaries, when I run the following command:
>
> fio.exe --thread --direct=1 --output-format=json --output=\fio.results.192.168.1.53.json --name=writeTestFile --filename=E\:\throughput.tst --size=100m --rw=write --bs=256k --iodepth=2 --buffer_comp ress_percentage=0
>
> The test completes (gets to 100%) and then crash:
>
> Faulting application name: fio.exe, version: 0.0.0.0, time stamp: 0x57bf1de1
> Faulting module name: msvcrt.dll, version: 7.0.9600.16384, time stamp: 0x5215f944
> Exception code: 0xc0000005
> Fault offset: 0x0000000000003209
> Faulting process id: 0x914
> Faulting application start time: 0x01d218fd8209cc06
> Faulting application path: c:\fio\fio-2.13-x64\fio.exe
> Faulting module path: C:\Windows\system32\msvcrt.dll
> Report Id: 6ca2ff1e-84f1-11e6-80c4-06db2ed6a2ef
> Faulting package full name:
> Faulting package-relative application ID:
>
> The output file (--output=\fio.results.192.168.1.53.json) is empty.
>
> I was able to narrow the problem to creating json output, e.g., when text output is requested, the crash does not happen.
>
> fio.exe --version
> fio-2.14

Does this still happen in current -git? It's too bad the windows version
doesn't generate the git sha, Bruce, any chance that could get added?

-- 
Jens Axboe


