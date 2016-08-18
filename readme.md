# MTA API 

## Setup

1. Install gems:

    ```
    bundle install
    ```

1. Start the server:

    ```
    rackup
    ```

---

## Usage

Request a single train with the q=name parameter. 

GET: `/api/v1/trains/L`
```json
{
    "train":"L",
    "status":"DELAYS"
}
```
You can requst the detailed status of the train with the long=true param. By default it is false.

This detailed response is kinda shitty. *Accepting pull requests for whoever wants to attempt cleaning it up.* 

GET: `api/v1/trains/L?long=true`
```json
{
    "train":"L",
    "status":"DELAYS",
    "info":"\n                    
<span class=\"TitleDelay\">Delays</span>\n
<span class=\"DateStyle\">\n                    &nbsp;Posted:&nbsp;08/18/2016&nbsp; 1:51PM\n                    </span>
<br/>
<br/>\n                  Following an earlier incident at
<STRONG>Sutter Av</STRONG>, [L] train service has resumed with residual delays.\n
<br/>
<br/>\n              "
}
```

or you can get all the trains: 

GET `/api/v1/trains`
```json
[
  {
    "train": "1",
    "status": "SERVICE CHANGE"
  },
  {
    "train": "2",
    "status": "SERVICE CHANGE"
  },
  {
    "train": "3",
    "status": "SERVICE CHANGE"
  },
  {
    "train": "4",
    "status": "GOOD SERVICE"
  },
  {
    "train": "5",
    "status": "GOOD SERVICE"
  },
  {
    "train": "6",
    "status": "GOOD SERVICE"
  },
  {
    "train": "7",
    "status": "GOOD SERVICE"
  },
  {
    "train": "A",
    "status": "GOOD SERVICE"
  },
  {
    "train": "C",
    "status": "GOOD SERVICE"
  },
  {
    "train": "E",
    "status": "GOOD SERVICE"
  },
  {
    "train": "B",
    "status": "GOOD SERVICE"
  },
  {
    "train": "D",
    "status": "GOOD SERVICE"
  },
  {
    "train": "F",
    "status": "GOOD SERVICE"
  },
  {
    "train": "M",
    "status": "GOOD SERVICE"
  },
  {
    "train": "G",
    "status": "GOOD SERVICE"
  },
  {
    "train": "J",
    "status": "SERVICE CHANGE"
  },
  {
    "train": "Z",
    "status": "SERVICE CHANGE"
  },
  {
    "train": "L",
    "status": "DELAYS"
  },
  {
    "train": "N",
    "status": "GOOD SERVICE"
  },
  {
    "train": "Q",
    "status": "GOOD SERVICE"
  },
  {
    "train": "R",
    "status": "GOOD SERVICE"
  },
  {
    "train": "S",
    "status": "GOOD SERVICE"
  }
]
```