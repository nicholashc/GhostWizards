//rough order of magnitude of search space
const max = 5000;
let arr = [];

//sort by numbers not strings because javascript...
const sortNum = (a, b) => {
  return a > b ? 1 : b > a ? -1 : 0;
}

const rand = () => {
    for (let i = 0; i < max; i++) {
        arr.push(Math.floor(Math.random() * max))
    }
}

//gen p-random array
rand()

//log initial array (stringified to show more than 100)
console.log(JSON.stringify(arr))

//log sorted array
console.log(JSON.stringify(arr.sort(sortNum)))
