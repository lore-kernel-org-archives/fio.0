Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
Subject: Re: Python scripts - /usr/bin/env python3 vs python vs python2.7
References: <d9332e23-633e-c4c0-381b-b2fcbd983e15@bsdio.com>
 <87ec264a-c0cd-2868-4173-f7d52297e7d5@gmail.com>
 <CS1PR8401MB1237B6211F30F9C8C1450CE1ABB10@CS1PR8401MB1237.NAMPRD84.PROD.OUTLOOK.COM>
 <CALjAwxgPF_oHQgDMr+v8y6r1AKbMUf9PKLxdctCugY4CHPy27w@mail.gmail.com>
From: Vincent Fu <vincentfu@gmail.com>
Message-ID: <0a1c5a62-3cb7-3543-77f9-cab03f07d028@gmail.com>
Date: Thu, 28 May 2020 15:24:45 -0400
MIME-Version: 1.0
In-Reply-To: <CALjAwxgPF_oHQgDMr+v8y6r1AKbMUf9PKLxdctCugY4CHPy27w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>, "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc: Rebecca Cran <rebecca@bsdio.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 5/28/20 4:19 AM, Sitsofe Wheeler wrote:
> Hi,
> 
> On Wed, 27 May 2020 at 20:23, Elliott, Robert (Servers) <elliott@hpe.com> wrote:
>>
>>> From: fio-owner@vger.kernel.org <fio-owner@vger.kernel.org> On Behalf
>>> Of Vincent Fu
>>> Sent: Tuesday, May 26, 2020 9:33 AM
>>> To: Rebecca Cran <rebecca@bsdio.com>; fio@vger.kernel.org
>>> Cc: Jens Axboe <axboe@kernel.dk>
>>> Subject: Re: Python scripts - /usr/bin/env python3 vs python vs
>>> python2.7
>>>
>>> On 5/26/20 10:13 AM, Rebecca Cran wrote:
>>>> Python scripts in fio use a variety of methods to run the python
>>>> interpreter: t/run_fio_tests.py has "#!/usr/bin/env python3" while
>>>> t/strided.py has "#!/usr/bin/python", and sgunmap-test.py has
>>>> "#!/usr/bin/python2.7".
>>>>
>>>>
>>>> Would there any interest in converting them all to use
>>>> "#!/usr/bin/env python3 ?
>>>
>>> I think having a uniform python interpreter line would be a good
>>> thing.
>>
>> I have been using python a lot recently and also noticed that the
>> /usr/bin/env format is the preferred approach; it works best across
>> linux distros, local installs, and is even recognized by Python in
>> Windows.
> 
> I'm guessing that's only in git for windows style shells? Surely
> native Windows will just look at the extension and then look in the
> registry?
> 
>> Most of the scripts include comments claiming python3 compatibility;
>> one does not.
>>
>> t/sgunmap-perf.py:#!/usr/bin/python2.7
>> t/sgunmap-perf.py:# REQUIREMENTS
>> t/sgunmap-perf.py:# Python 2.6+
>>
>> t/sgunmap-test.py:#!/usr/bin/python2.7
>> t/sgunmap-test.py:# Note: this script is python2 and python 3 compatible.
>>
>> t/steadystate_tests.py:#!/usr/bin/env python
>> t/steadystate_tests.py:# Note: this script is python2 and python3 compatible.
>>
>> t/strided.py:#!/usr/bin/python
>> t/strided.py:# Note: this script is python2 and python3 compatible.
>>
>> tools/fiologparser.py:#!/usr/bin/python2.7
>> tools/fiologparser.py:#!/# Note: this script is python2 and python 3 compatible.
> 
> I second the suggestion that a single interpreter. Ages ago
> (https://github.com/axboe/fio/commit/60023ade47e7817db1c18d9b7e511839de5c2c99
> )  switched the interpreter to /usr/bin/python2.7 on scripts of the
> time to make life easier on macOS and as a compromise to the distros
> (which stated that env should not be used for their packages).
> 
> These days we have some python3 only scripts, some distros have to
> patch the interpreter line to be python3 anyway
> (https://src.fedoraproject.org/rpms/fio/c/b45ecfbe7170bbd6f5b2bec2a33e3c0e3d17d1d2?branch=master
> ) and will seemingly auto-convert env interpreter usage
> (https://docs.fedoraproject.org/en-US/packaging-guidelines/#_shebang_lines
> ) at packaging time, some OS package guidelines say you should ONLY
> use env interpreter lines (I think this is the case for NetBSD's
> pkgsrc), macOS will eventually stop shipping python 2.7 default:
> 
> WARNING: Python 2.7 is not recommended.
> This version is included in macOS for compatibility with legacy software.
> Future versions of macOS will not include Python 2.7.
> 
> and it will only ship python3 as part of its developers tools (or the
> user will have to get it some other way such as homebrew etc).
> 
> Given the above, I think the best thing is just to use "#!/usr/bin/env
> python3" everywhere and at least:
> - That's nicer to environments that don't have a python interpreter in /usr/bin
> - Nicer if you ever run the scripts in a virtualenv
> - Packagers can fix it up to whatever they like and at least the
> pattern is the same across the board
> 
> I guess the things to do are:
> - Check if the script that doesn't claim python3 compat already works
> or can be fixed up
> - Change all the hashbang lines and throw away the comments talking
> about 2+3 compat
> 
> It would be good if any such commit mentions that it
> "fixes"/supercedes https://github.com/axboe/fio/pull/874 ...
> 

I have a pull request that changes the shebang lines for 
t/steadystate_tests.py and t/strided.py:

https://github.com/axboe/fio/pull/1000

I did not make changes to t/sgunmap-*.py. I originally wrote them when 
testing the sg unmap operation on SAS SSDs but I no longer have access 
to those devices. I saw errors when I tried to issue sg unmap commands 
to SATA SSDs.

As for the scripts in the tools subdirectory, the change is trivial to 
make and test for fio_jsonplus_clat2csv because there is a test script 
for the tool.

However, tools/fiologparser.py is currently broken because the logging 
format was changed. The same problem exists for tools/plot/fio2gnuplot 
and was reported and diagnosed at:

https://github.com/axboe/fio/issues/928

I don't know enough about the scripts in tools/hist to comment on them.

Updating the tools scripts will take a bit of effort.

