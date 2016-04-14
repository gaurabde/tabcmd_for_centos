# tabcmd_for_centos (version 7)

## For CentOS environment(vagrant box):
---------------------------
---------------------------

### 1.1 Install virtualbox:
-----------------------
```sudo vim /etc/yum.repos.d/virtualbox.repo```

add below text
```
[virtualbox]
name=Oracle Linux / RHEL / CentOS-$releasever / $basearch - VirtualBox
baseurl=http://download.virtualbox.org/virtualbox/rpm/el/$releasever/$basearch
enabled=1
gpgcheck=1
gpgkey=http://virtualbox.org/virtualbox/download/oracle_vbox.asc
```
#### For CentOS/RHEL 7, 64 Bit (x86_64): 
rpm -Uvh http://ftp.jaist.ac.jp/pub/Linux/Fedora/epel/7/x86_64/e/epel-release-7-5.noarch.rpm

#### Install packages:
```
sudo yum install gcc make patch  dkms qt libgomp 
sudo yum install kernel-headers kernel-devel fontforge binutils glibc-headers glibc-devel
```

**NOTE:** VirtualBox need kernel vesion to install dependencies, so export environment variable:

```export KERN_DIR=/usr/src/kernels/<check_kernel_version>```


(Vagrant instalation using gem will be deprecated soon)

### 1.2 Get Centos/7 vagrant file and run:
-----------------------------------
Install `vagrant` (Vagrant instalation using gem will be deprecated soon):

```
gem install vagrant
vagrant init centos/7; vagrant up --provider virtualbox

# get vagrant id
vagrant global-status

```

#### 1.3 Clone repo:

```
sudo yum install git-core
git clone https://github.com/gaurabde/tabcmd_for_centos.git
```

##### To run existing tabcmd version 7 (from following repo)

* [Install ruby version >= 2.0.0](https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-on-centos-6-with-rvm)

```
cd tabcmd_for_centos
gem install `for i in ../../gems/*  ; do (echo \`basename $i\` | cut -f 1 -d '-') ; done `
```
* jump to *step 3*


### 2. Custome configuration
-----------------------

**NOTE**: If you are using your own `tabcmd.jar`
```
uzip tabcmd.jar

# install all required gems
gem install `for i in ../../gems/*  ; do (echo \`basename $i\` | cut -f 1 -d '-') ; done `
```

#### 2.1 Remove tabutil reference :mute: to aviod runtime errors
* Move/Remove `tabutil.rb` file:
```
mv common/ruby/lib/tabutil.rb common/ruby/lib/tabutil.rb_old
```
* update code to remove **reference** from `dump_reporter.rb` 
```
vim common/ruby/lib/dump_reporter.rb

```
```
#change ---
#require 'tabutil'
#----
class DumpReporter
  def initialize(app_name, log_dir, exit_on_exception)
  #changes ---
    #Tabutil::Tabutil.setup_fault_reporting(log_dir.to_s.gsub('/', '\\'),
    #                                       app_name, true, exit_on_exception)
    #ObjectSpace.define_finalizer(self, lambda { Tabutil.destroy_fault_reporting })
  # -----
  end

  def self.setup(app_name, log_dir, exit_on_exception)
    $dump_reporter = DumpReporter.new(app_name, log_dir, exit_on_exception)
  end

  def self.force_crash
  # changes ----
    #Tabutil.force_fault
  # ------
  end
end
```

#### 2.2 Update code to change **working directory** (`relative_path.rb`)

```
vim ./common/ruby/lib/relative_path.rb

```

```
## when invoked via tablaunchjava, the current-working-directory may (likely) be different that where the user invoked tabcmd
## This Module and helper-routine can fixup relative paths to be from the original launch-dir
module RelativePath
  def self.fix_path(incoming)
    return nil unless incoming
    p = Pathname.new(incoming)
    return incoming if p.absolute?
    # change ----
    #tableau_working_dir = java.lang.System.get_property("tableau.working.dir")
    tableau_working_dir = "."
    # ------
    if tableau_working_dir
      return File.expand_path(incoming, tableau_working_dir)
    end
    return incoming
  end
end
```

#### 2.3 Create environemnt variable
```
export APPDATA=~/Documents/tableau_for_centos/tabcmd_jar/tabcmd
```

* change Gemfile
```
copy gem file from tableau_for_centos/tabcmd_jar/tabcmd
```

* Execute bundle to install required gems

```
bundle install 
#if fails 
bundle update
```

* Install gems for safty, if is not installed duing bundle:  :see_no_evil:
```
gem install log4r --no-document
gem install rchardet --no-document
gem install iconv --no-document
gem install rails --no-document
```

### 3. Run tabcmd:
```
bin/tabcmd.rb login -U <user_name> -s <server_url>
```

### Error while running `tabcmd.rb` :bangbang: :

```
/tabcmd/lib/server_info.rb:1: unknown encoding name: raw-text (ArgumentError)
```
 **solution**: remove line 1 from server_infor.rb 
 
```
uninitialized constant ActiveSupport::Autoload (NameError)
```
 **solution**: add ``` require 'active_support'``` to bin/tabcmd.rb


Tags: Tableau, tabcmd, CentOS, Linux, tabcmd version 7, Tableau Server command line tool
