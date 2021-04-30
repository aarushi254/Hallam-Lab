%%
Depth = NosZseqsMetaGsubset.Depth;
Abundance = NosZseqsMetaGsubset.SumAbundance;
Time = NosZseqsMetaGsubset.Date;

%[~, sort_idx] = sort(nosZseqsMetaGsubset);
%ordered_legends = nosZseqsMetaGsubset.treeSAPP_phylum(sort_idx);

[unique_groups,~, group_idx] = unique(NosZseqsMetaGsubset.TreeSAPP_phylum);
num_groups = size(unique_groups, 1);
group_names = mat2cell(unique_groups, ones(1, num_groups), size(unique_groups, 2));

point_size = 30;
scatter3(Depth, Time, Abundance, point_size, group_idx, 'filled');

cmap = jet(num_groups);
colormap(cmap);

xlabel('Depth')
ylabel('Time')
zlabel('Abundance')
title('Sumed Abundances across all taxa for NosZ MetaG')
legend(group_names);

%view(26, 42)

