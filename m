Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Fri, 22 May 2020 01:13:12 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 7/9] fio: parse "io_size=1%"
Message-ID: <20200521221312.GA7915@avx2>
References: <20200505175634.2517-1-adobriyan@gmail.com>
 <20200505175634.2517-7-adobriyan@gmail.com>
 <BY5PR04MB69004E2F74EE3F2588959212E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BY5PR04MB69004E2F74EE3F2588959212E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Mon, May 11, 2020 at 01:20:32AM +0000, Damien Le Moal wrote:
> On 2020/05/06 2:57, Alexey Dobriyan wrote:
> > The following config:
> > 
> > 	size=1%
> > 	io_size=1%
> > 
> > will generate essentially infinite loop, because io_size is set to (2^64-1)-1.
> > 
> > Parse io_size as percentage to avoid the bug.
> > 
> > Note: if size% != io_size%, io_size is ignored but it is separate bug.
> > 
> > Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
> > ---
> >  cconv.c          |  2 ++
> >  options.c        | 17 +++++++++++++++++
> >  server.h         |  2 +-
> >  thread_options.h |  4 ++++
> >  4 files changed, 24 insertions(+), 1 deletion(-)
> > 
> > diff --git a/cconv.c b/cconv.c
> > index 48218dc4..48b0db9e 100644
> > --- a/cconv.c
> > +++ b/cconv.c
> > @@ -102,6 +102,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
> >  	o->size = le64_to_cpu(top->size);
> >  	o->io_size = le64_to_cpu(top->io_size);
> >  	o->size_percent = le32_to_cpu(top->size_percent);
> > +	o->io_size_percent = le32_to_cpu(top->io_size_percent);
> >  	o->fill_device = le32_to_cpu(top->fill_device);
> >  	o->file_append = le32_to_cpu(top->file_append);
> >  	o->file_size_low = le64_to_cpu(top->file_size_low);
> > @@ -366,6 +367,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
> >  	top->iodepth_batch_complete_max = cpu_to_le32(o->iodepth_batch_complete_max);
> >  	top->serialize_overlap = cpu_to_le32(o->serialize_overlap);
> >  	top->size_percent = cpu_to_le32(o->size_percent);
> > +	top->io_size_percent = cpu_to_le32(o->io_size_percent);
> >  	top->fill_device = cpu_to_le32(o->fill_device);
> >  	top->file_append = cpu_to_le32(o->file_append);
> >  	top->ratecycle = cpu_to_le32(o->ratecycle);
> > diff --git a/options.c b/options.c
> > index 47b3b765..3d0c3a84 100644
> > --- a/options.c
> > +++ b/options.c
> > @@ -1475,6 +1475,22 @@ static int str_size_cb(void *data, unsigned long long *__val)
> >  	return 0;
> >  }
> >  
> > +static int str_io_size_cb(void *data, unsigned long long *__val)
> > +{
> > +	struct thread_data *td = cb_data_to_td(data);
> > +	unsigned long long v = *__val;
> > +
> > +	if (parse_is_percent(v)) {
> > +		td->o.io_size = 0;
> > +		td->o.io_size_percent = -1ULL - v;
> > +		dprint(FD_PARSE, "SET io_size_percent %d\n",
> > +					td->o.io_size_percent);
> 
> I do not see where f->io_size is set using td->o.io_size_percent. Isn't it
> needed to set it somewhere in filesetup.c ?

I recall what bugs me about this code.

It would be correct to use io_size_percent and write this:

	        if (f->io_size == -1ULL)
                        total_size = -1ULL;
                else {
                        if (o->io_size_percent && o->io_size_percent != 100) {
                                uint64_t file_size;

                                file_size = f->io_size + f->file_offset;
                                f->io_size = (file_size *
                                              o->io_size_percent) / 100;
                                if (f->io_size > (file_size - f->file_offset))
                                        f->io_size = file_size - f->file_offset;

                                f->io_size -= (f->io_size % td_min_bs(td));
                        }
                        total_size += f->io_size;
                }

f->io_size is 1M and total of 40MB worth I/O is emitted with this config
which is arguably not correct. It should be 20MB.

	[global]
	filename=/dev/loop0	# 1GB
	direct=1
	thread
	rw=write
	bs=4096
	ioengine=psync
	[j]
	offset=1M
	size=1M
	io_size=2%

	WRITE: bw=39.1MiB/s (40.0MB/s), 39.1MiB/s-39.1MiB/s (40.0MB/s-40.0MB/s), io=40.0KiB (40.0kB)

