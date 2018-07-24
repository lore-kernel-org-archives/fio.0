Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] idle-prof: append output cpu idleness data to terse log
References: <925A83423110DA4D836092D40AC7A7E8084E0DEE@APYOKXMS108.ap.sony.com>
 <AT5PR8401MB116995DF0FE7729E290EEAB5AB5C0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <CAB-428=sjscbp4UoagO41K102Ba=Ng5uoXhVgCO4Uix4+zEg_g@mail.gmail.com>
 <CALjAwxgEqChgK++6YHxg7gCyGxT4=dCAy7cZNqOgHhC==cHuQA@mail.gmail.com>
 <CAB-428m9DFwvCUu6VOpF-mQkYxFWeb5VM-s4HcQC_F+DGw1xgg@mail.gmail.com>
 <AT5PR8401MB1169740953CAF420D64D20DCAB530@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <183ae5ea-594e-5197-d54a-3a8955e6b5f1@kernel.dk>
Date: Tue, 24 Jul 2018 09:40:33 -0600
MIME-Version: 1.0
In-Reply-To: <AT5PR8401MB1169740953CAF420D64D20DCAB530@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Alireza Haghdoost <haghdoost@gmail.com>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "Friendy.Su@sony.com" <Friendy.Su@sony.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "No.Tanaka@sony.com" <No.Tanaka@sony.com>, "Hajime.Tomura@sony.com" <Hajime.Tomura@sony.com>
List-ID: <fio@vger.kernel.org>

On 7/17/18 9:18 PM, Elliott, Robert (Persistent Memory) wrote:
> 
> 
>> -----Original Message-----
>> From: Alireza Haghdoost <haghdoost@gmail.com>
>> Sent: Tuesday, July 17, 2018 2:25 PM
>> To: Sitsofe Wheeler <sitsofe@gmail.com>
>> Cc: Elliott, Robert (Persistent Memory) <elliott@hpe.com>;
>> Friendy.Su@sony.com; fio@vger.kernel.org; No.Tanaka@sony.com;
>> Hajime.Tomura@sony.com
>> Subject: Re: [PATCH] idle-prof: append output cpu idleness data to
>> terse log
>>
>> On Tue, Jul 17, 2018 at 2:13 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>>
>>> On 17 July 2018 at 15:30, Alireza Haghdoost <haghdoost@gmail.com> wrote:
>>>> On Tue, Jul 17, 2018 at 9:18 AM, Elliott, Robert (Persistent Memory) ...
>>>>> Since the terse format is not self-describing, new fields require
>>>>> a version bump (see -terse-version).
>>>>>
>>>>> Maybe one of the versions should print out the field names as the first
>>>>> line, so it becomes self-describing.  I guess the json format already
>>>>> provides that functionality, so it might not be necessary.
>>>>>
>>>> How about adding an extra command option like --terse-header that
>>>> prints out the header only? It is hard to keep track of these version
>>>> changes in one place at the user manual or some blog post.
>>>> with a terse header command option, I can ignore the terse version and
>>>> adjust my test scripts to query the header first before running the
>>>> test, then pull the right column after the test finishes.
>>>
>>> You would then need to document all the terse formats because you
>>> never know which one someone will use (it looks like there are four:
>>> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-terse-version
>>> ). At this stage shouldn't we be nudging people towards JSON which is
>>> more self describing and easier to extend in a backwards compatible
>>> manner?
>>
>> I am on board with your suggestion but not every user might have a
>> time/resource to re-implement their existing test script to work with
>> json. We should stop adding more versions of the terse. Otherwise, If
>> we want to continue supporting the terse format, I recommend to
>> figure out a programmatic way to handle its complexity.
> 
> How about defining that the next terse version always includes
> a header line, so it'll be self-describing and can be the final
> terse version.

I like that idea. We already have a version at the front, proper scripts
should be checking that, and we can further make it safer by adding
new fields at the end.

Honestly, I really dislike the terse format. But it's there and some
people like to use it, and it's a shame if we can add new additions. It's
already trailing the json/normal output in various cases, for instance
it doesn't include fsync output (and I'm sure others). If at all possible,
I always push people towards json instead of the nasty terse output.

-- 
Jens Axboe


