# BulkUpdater

Generate and execute SQL UPDATE for bulk updating multiple records by one request.

## Usage

    BulkUpdater.update!(model, columns_to_find, columns_to_update, data)

Input params:

- `model` - model which table must be updated.

- `columns_to_find` - array of columns for when condition.
                  Must be array of symbols.

- `columns_to_update` - array of columns for updating.
                    Must be array of symbols.

- `data` - array with all required data. Must be array of hashes. Each hash must contain all columns_to_find and required columns to update.

## Example:

    data = [{author_id: 1, is_adult: 1, name: 'Name 1', price: 9.99},
            {author_id: 2, is_adult: 1, name: 'Name 2'}]
    BulkUpdater.update!(App, [:author_id, :is_adult], [:name, :price], data)

executes SQL like:

    UPDATE apps
      SET name = case
        when author_id = 1 and is_adult = 1 then 'Name 1'
        when author_id = 2 and is_adult = 1 then 'Name 2'
        else name
      end,
      price = case
        when author_id = 1 and is_adult = 1 then 9.99
        else price
      end
    WHERE author_id IN (1, 2) AND is_adult IN (1)

## Notes

- Gem has fairly straightforward logic for generating SQL request. It generates only one type of request(as shown in example).
- There are limitaions in idea. You can not find record by key and update the same key. E.g., `columns_to_find` and `columns_to_update` can not intersect.
- Yet no tests. I've just extracted library from real project, it really works, but I still have to idea how to write clean unit tests. Any ideas appreciated.
- Again: any ideas appreciated.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/bulk_updater/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
