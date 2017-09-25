<template>
  <div>
    <h3><u>Filtered items: {{currentMembers.length}}</u></h3>
    <h3><u>Total length: {{this.genes.length}}</u></h3>
    <div class="table-responsive">
      <table class="table table-striped">
        <tr>
          <th>ID</th>
          <!-- <th>Start</th> -->
          <!-- <th>End</th> -->
          <th>Gene</th>
          <th>Description</th>
          <th>Attributes</th>
        </tr>
        <tbody>
          <tr v-for="item in currentMembers">
            <td>{{item.seqid}}</td>
            <!-- <td>{{item.start}}</td> -->
            <!-- <td>{{item.end}}</td> -->
            <td>{{item.attributes.gene}}</td>
            <td>{{item.attributes.description}}</td>
            <td>{{item.attributes}}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
  import genes from '~/static/GRCh38.json'
  // import genes from '~/static/deneme.json'

  export default {
    data: function () {
      return {
        'text': this.$route.params.text,
        'genes': genes
      }
    },
    components: {
    },
    methods: {
      searchStringArrayObject: function (undefinedDataType, regex) {
        if (undefinedDataType.constructor === Array) {
          if (undefinedDataType[0].constructor === String) {
            if (undefinedDataType.join(' ').search(this.regex) > -1) {
              return true
            }
          } else if (undefinedDataType[0].constructor === Object) {
            let valuesList = []
            undefinedDataType.forEach(function (item) {
              valuesList.push(Object.values(item)[0])
            })
            if (valuesList.join(' ').search(this.regex) > -1) {
              return true
            }
          }
        } else if (undefinedDataType.constructor === Object) {
          if (Object.values(undefinedDataType).join(' ').search(this.regex) > -1) {
            return true
          }
        } else if (undefinedDataType.constructor === String) {
          if (undefinedDataType.search(this.regex) > -1) {
            return true
          }
        }
        return false
      },
      searchObject: function (geneObject) {
        if (geneObject.attributes.gene.search(this.regex) > -1) {
          return true
          //if eq 100 90
        }
        if (geneObject.attributes.gene_synonym) {
          if (this.searchStringArrayObject(geneObject.attributes.gene_synonym, this.regex)) {
            return true
            //if eq one of them 80 else 70
          }
        }
        if (geneObject.attributes.ID) {
          if (this.searchStringArrayObject(geneObject.attributes.ID, this.regex)) {
            return true
            //if eq one 80 else 50
          }
        }
        if (geneObject.attributes.Dbxref) {
          if (this.searchStringArrayObject(geneObject.attributes.Dbxref, this.regex)) {
            return true
            //if eq one 80 else 50
          }
        }
        if (geneObject.attributes.description !== undefined) {
          if (this.searchStringArrayObject(geneObject.attributes.description, this.regex)) {
            return true
            //60
          }
        }
        return false
      }
    },
    head: {
      script: [
        {src: 'https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.1/jquery.min.js'},
        {src: 'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js'}
      ]
    },
    computed: {
      regex: function () {
        // let self = this
        let re = new RegExp(this.text, 'gi')
        return re
      },
      currentMembers: function () {
        let self = this
        let found = genes.filter(function (item) {
          // if (item.attributes.gene.toLowerCase().indexOf(self.text.toLowerCase()) > -1) {
          if (self.searchObject(item)) {
            return item
          }
        })
        return found
      }
    }
  }
</script>
