Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: Vincent Fu <vincentfu@gmail.com>
Subject: Re: automated notification for fio releases
References: <0f34b150-5f5f-6f01-9c19-e04830c9d4ee@gmail.com>
 <CALjAwxhSCN+5C9oRG34rdLc6NKnPUkNO+ND7X=p6fTWemuMsMg@mail.gmail.com>
 <7dda5da1-bcbd-e338-60ec-aac424784892@gmail.com>
 <ba464a20-de84-81fc-24d9-d67356022c1a@kernel.dk>
Message-ID: <09ffd9d0-3f96-b838-a589-4cb635e18ca7@gmail.com>
Date: Sat, 3 Nov 2018 19:15:59 -0400
MIME-Version: 1.0
In-Reply-To: <ba464a20-de84-81fc-24d9-d67356022c1a@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 11/3/18 5:53 PM, Jens Axboe wrote:
> On 10/31/18 2:28 PM, Vincent Fu wrote:
>> On 10/31/18 11:05 AM, Sitsofe Wheeler wrote:
>>> On Tue, 30 Oct 2018 at 20:26, Vincent Fu <vincentfu@gmail.com> wrote:
>>>>
>>>> Does anyone know of a means to be automatically notified of new fio
>>>> releases?
>>>>
>>>> I have seen Jens post announcements via Twitter, but that is not a
>>>> social media platform I actively use. As far as I can tell, Github does
>>>> not provide a means to be notified of new releases.
>>>>
>>>> Perhaps the solution is to monitor http://brick.kernel.dk/snaps/ for new
>>>> fio shortlog files.
>>>
>>> I think there are few things that are doing monitoring of this.
>>> Repology ( https://repology.org/metapackage/fio/packages ) seems to
>>> have some way of knowing, Fedora seem to use
>>> https://release-monitoring.org/project/806/ and I think Debian have
>>> their own watcher (https://qa.debian.org/cgi-bin/watch?pkg=fio ). You
>>> might also be able to tell via github
>>> (https://github.com/axboe/fio/releases and I think there are atom
>>> feeds off that page).
>>>
>>
>> Thanks, Sitsofe. That helps a lot. I am actually seeking to be notified
>> via email of new releases.
>>
>> I signed up to be notified of fio release-monitoring.org changes via
>> Fedora notifications (https://apps.fedoraproject.org/notifications),
>> although the filter I created only produced example matches with fio-3.8
>> and did not pick up any later releases.
>>
>> I also set up an IFTTT rule to receive email messages when updates are
>> made to the github fio release atom feed
>> (https://github.com/axboe/fio/releases.atom).
>>
>> Finally, I signed up to be notified via https://newreleases.io/.
>>
>> With any luck I should be bombarded with notifications when fio 3.12 is
>> tagged.
> 
> Did it work?
> 
> FWIW, this list does receive any changes that were pushed to the git
> repo. As tags are pushed, you'd see that in the "Recent changes" email
> the next day. Not great, but it's something.
> 
> I don't announce all releases to twitter, and sometimes it'll be a day
> or two before I do. Case in point, the 3.12 release hasn't been
> announced there yet.
> 

The atom feed for the github releases page now has an entry for fio 
3.12. I see it in my news reader and I received an email for it from the 
IFTTT RSS feed to email rule I created.

I also received an email from https://newreleases.io.

fio 3.12 has also appeared on 
https://release-monitoring.org/project/806/ but I haven't received a 
notification from the Fedora Notifications system. Either I've set it up 
wrong or it doesn't work.

